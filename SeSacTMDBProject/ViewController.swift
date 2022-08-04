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



class ViewController: UIViewController {
    
    // MARK: - Propertys
    var mediaDataManager = TMDBDataManager()
    
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
        searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController
    }
    
    
    func setNavigationBar() {
        self.navigationItem.title = "TMDB"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    func requestTranslatedData(mediaType: MediaType, timeWindow: TimeWindow, page: Int) {
        let url = EndPoint.TMDBEndPoint + "\(mediaType.rawValue)/\(timeWindow.rawValue)?api_key=\(APIKeys.TMDBKEY)&page=\(page)"
        
        AF.request(url, method: .get).validate(statusCode: 200...500).responseData { [unowned self] response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)

                let statusCode = response.response?.statusCode ?? 500
                
                if 200..<300 ~= statusCode {
                    
                    json["results"].arrayValue.forEach {
                        let title = $0["title"].stringValue
                        let description = $0["overview"].stringValue
                        let releaseDate = $0["release_date"].stringValue
                        let genres = mediaDataManager.getGenres(key: $0["genre_ids"][0].intValue)
                        let grade = $0["vote_average"].doubleValue
                        let imageURL = $0["backdrop_path"].stringValue
                        
                        let mediaData = TMDBMedia(title: title, description: description, releaseDate: releaseDate, genres: genres, grade: grade, imageURL: imageURL)
                        mediaDataManager.addMediaData(newData: mediaData)
                    }
                    
                    totalPage = json["total_pages"].intValue
                    startPage += 1
                    
                    collectionView.reloadData()
                    
                }else {
                    print("STATUSCODE : \(statusCode)")
                }
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func requestGenres() {
        let url = EndPoint.GenreURL
        
        AF.request(url, method: .get).validate(statusCode: 200...500).responseData { [unowned self] response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)

                let statusCode = response.response?.statusCode ?? 500

                if 200..<300 ~= statusCode {
                    
                    json["genres"].arrayValue.forEach {
                        let key = $0["id"].intValue
                        let value = $0["name"].stringValue
                        mediaDataManager.addGenres(key: key, genre: value)
                    }
                    
                }else {
                    print("STATUSCODE : \(statusCode)")
                }
                
                
            case .failure(let error):
                print(error)
            }
        }
        
        requestTranslatedData(mediaType: .movie, timeWindow: .week, page: startPage)
    }
}



// MARK: - CollectionView Protocol
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as? SearchResultCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.updateCell(by: mediaDataManager.getMediaData(at: indexPath.row))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaDataManager.count
    }
    
    
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



extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 검색 => 현재 데이터 삭제 후 네트워킹
    }
}



// MARK: - Pagenation) DataSourcePrefetching
extension ViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if mediaDataManager.count - 1 == indexPath.item && startPage < totalPage {
                requestTranslatedData(mediaType: .movie, timeWindow: .week, page: startPage)
            }
        }
    }
    
    
}
