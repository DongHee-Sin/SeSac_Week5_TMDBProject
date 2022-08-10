//
//  ViewController.swift
//  SeSacTMDBProject
//
//  Created by 신동희 on 2022/08/03.
//

import UIKit

import Alamofire
import SwiftyJSON


enum MediaType: String {
    case all, movie, tv, person
}

enum TimeWindow: String {
    case day, week
}



class TrendingListViewController: UIViewController, CommonSetting {
    
    static let identifier: String = String(describing: TrendingListViewController.self)
    
    // MARK: - Propertys
    var mediaDataManager = TMDBDataManager.shared
    
    var totalPage = 0
    var startPage = 1
    
    
    
    // MARK: - Outlet
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureInitialUI()
        
        requestGenres()
    }


    
    // MARK: - Methods
    func configureInitialUI() {
        collectionView.backgroundColor = .clear
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        
        collectionView.register(UINib(nibName: SearchResultCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
        
        collectionView.collectionViewLayout = configureCollectionViewLayout(rowCount: 1)
        
        setSearchController()
        setNavigationBar()
    }
    
    
    func setSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchResultsUpdater = self
        
        self.navigationItem.searchController = searchController
    }
    
    
    func setNavigationBar() {
        self.navigationItem.title = "TMDB"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    func presentWebView(linkKey: String) {
        guard let webVC = storyboard?.instantiateViewController(withIdentifier: WebViewController.identifier) as? WebViewController else {
            return
        }
        
        webVC.linkKey = linkKey
        
        present(webVC, animated: true)
    }
    
    
    // MARK: - Network
    func requestTranslatedData(mediaType: MediaType, timeWindow: TimeWindow, page: Int) {
        let url = EndPoint.TMDBEndPoint + "\(mediaType.rawValue)/\(timeWindow.rawValue)?api_key=\(APIKeys.TMDBKEY)&page=\(page)"
        
        APIManager.shared.requestAPI(url: url) { [unowned self] json in
            json["results"].arrayValue.forEach {
                let id = $0["id"].intValue
                let title = $0["title"].stringValue
                let description = $0["overview"].stringValue
                let releaseDate = $0["release_date"].stringValue
                let genres = mediaDataManager.getGenres(key: $0["genre_ids"][0].intValue)
                let grade = $0["vote_average"].doubleValue
                let imageURL = $0["backdrop_path"].stringValue
                let posterURL = $0["poster_path"].stringValue
                
                let mediaData = TMDBMedia(id: id, title: title, overView: description, releaseDate: releaseDate, genres: genres, grade: grade, backgroundImageURL: imageURL, posterImageURL: posterURL)
                
                mediaDataManager.addMediaData(newData: mediaData)
            }
            
            totalPage = json["total_pages"].intValue
            startPage += 1
            DispatchQueue.main.async { [unowned self] in
                collectionView.reloadData()
            }
        }
    }
    
    
    func requestGenres() {
        APIManager.shared.requestAPI(url: EndPoint.GenreURL) { [unowned self] json in
            json["genres"].arrayValue.forEach {
                let key = $0["id"].intValue
                let value = $0["name"].stringValue
                mediaDataManager.addGenres(key: key, genre: value)
            }
        }
        
        requestTranslatedData(mediaType: .movie, timeWindow: .week, page: startPage)
    }
    
    
    func requestYoutubeLink(mediaID: Int) {
        let url = EndPoint.webViewRequestEndpoint + "\(mediaID)/videos?language=en-US&api_key=\(APIKeys.TMDBKEY)"
        
        APIManager.shared.requestAPI(url: url) { [unowned self] json in
            let youtubeLinkKey = json["results"].arrayValue[0]["key"].stringValue
            
            DispatchQueue.main.async { [unowned self] in
                presentWebView(linkKey: youtubeLinkKey)
            }
        }
    }
}



// MARK: - CollectionView Protocol
extension TrendingListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as? SearchResultCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let mediaData = mediaDataManager.getMediaData(at: indexPath.row)
        
        cell.mediaID = mediaData.id
        cell.delegate = self
        cell.updateCell(by: mediaData)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaDataManager.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: MediaInfoViewController.identifier) as? MediaInfoViewController else {
            return
        }
        
        let movieData = mediaDataManager.getMediaData(at: indexPath.row)
        vc.media = movieData
        mediaDataManager.sawMovieInfo(title: movieData.title)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    // Layout
    func configureCollectionViewLayout(rowCount: CGFloat) -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        
        let sectionSpacing: CGFloat = 8
        let itemSpacing: CGFloat = 20
        
        let width: CGFloat = UIScreen.main.bounds.width - (itemSpacing * (rowCount-1)) - (sectionSpacing * 2)
        let itemWidth: CGFloat = width / rowCount
        
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing
        
        return layout
    }
}



// MARK: - Pagenation) DataSourcePrefetching
extension TrendingListViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if mediaDataManager.count - 1 == indexPath.item && startPage < totalPage {
                requestTranslatedData(mediaType: .movie, timeWindow: .week, page: startPage)
            }
        }
    }    
}



// MARK: - WebViewButton Delegate
extension TrendingListViewController: WebViewButtonDelegate {
    func webViewButtonTapped(mediaID: Int) {
        requestYoutubeLink(mediaID: mediaID)
    }
}



// MARK: - SearchController
extension TrendingListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        mediaDataManager.searchWord = searchController.searchBar.text ?? ""
        collectionView.reloadData()
    }
}
