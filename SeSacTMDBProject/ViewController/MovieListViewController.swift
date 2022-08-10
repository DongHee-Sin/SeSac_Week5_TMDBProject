//
//  MovieListViewController.swift
//  SeSacTMDBProject
//
//  Created by 신동희 on 2022/08/09.
//

import UIKit

import Kingfisher

class MovieListViewController: UIViewController, CommonSetting {
    
    static let identifier = String(describing: MovieListViewController.self)

    // MARK: - Propertys & Outlet
    @IBOutlet weak var tableView: UITableView!
    
    var someData: [[Int]] = [
        [Int](1...10),
        [Int](2...6),
        [Int](5...10),
        [Int](16...24),
        [Int](6...16)
    ]
    
    var recommendMovieList: [(String, [RecommendMovie])] = [] {
        didSet {
            if recommendMovieList.count == 10 {
                DispatchQueue.main.async { [unowned self] in
                    recommendMovieList = recommendMovieList.filter { (title, list) in
                        !list.isEmpty
                    }
                    tableView.reloadData()
                }
            }
        }
    }
    
    
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: MovieListTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: MovieListTableViewCell.identifier)
        
        configureInitialUI()
        
        TMDBDataManager.shared.interestMovieList.forEach { (id, title) in
            requestRecommendMovieInfo(id: id, title: title)
        }
    }
    

    
    // MARK: - Methods
    func configureInitialUI() {
        view.backgroundColor = .black
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
    }
    
    
    func requestRecommendMovieInfo(id: Int, title: String) {
        let url = EndPoint.recommendMovieEndPoint + "\(id)/recommendations?api_key=\(APIKeys.TMDBKEY)&language=en-US&page=1"
        
        APIManager.shared.requestAPI(url: url) { [unowned self] json in
            
            var list: [RecommendMovie] = []
            
            json["results"].arrayValue.forEach { movie in
                let title = movie["title"].stringValue
                let posterURL = movie["poster_path"].stringValue
                
                list.append(RecommendMovie(title: title, posterURL: posterURL))
            }
            
            recommendMovieList.append((title, list))
        }
    }
}



// MARK: - TableView Protocol
extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return recommendMovieList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieListTableViewCell.identifier, for: indexPath) as? MovieListTableViewCell else {
            return UITableViewCell()
        }
        
        cell.titleLabel.text = recommendMovieList[indexPath.section].0 + " 관련 영화"
        
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        cell.collectionView.register(UINib(nibName: MovieListCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: MovieListCollectionViewCell.identifier)

        cell.collectionView.tag = indexPath.section
        
        cell.collectionView.reloadData()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.width * 0.5
    }
}



// MARK: - CollectionView Protocol
extension MovieListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendMovieList[collectionView.tag].1.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListCollectionViewCell.identifier, for: indexPath) as? MovieListCollectionViewCell else {
            return UICollectionViewCell()
        }

        let urlString = EndPoint.TMDBImagePathEndPoint + recommendMovieList[collectionView.tag].1[indexPath.item].posterURL
        let url = URL(string: urlString)
        cell.posterView.posterImage.kf.setImage(with: url)
        
        return cell
    }
}
