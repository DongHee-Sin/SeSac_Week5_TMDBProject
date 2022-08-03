//
//  ViewController.swift
//  SeSacTMDBProject
//
//  Created by 신동희 on 2022/08/03.
//

import UIKit

import Alamofire
import SwiftyJSON


class ViewController: UIViewController {
    
    // MARK: - Propertys
    var mediaDataManager = TMDBDataManager()
    
    
    
    // MARK: - Outlet
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: SearchResultCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
        
        collectionView.collectionViewLayout = configureCollectionViewLayout(rowCount: 1)
        
        requestTranslatedData()
    }


    
    // MARK: - Methods
    func configureInitialUI() {
        collectionView.backgroundColor = .clear
    }
    
    
    func requestTranslatedData() {
        // URL 문자열
        let url = EndPoint.TMDBEndPoint + "movie" + "/" + "week" + "?api_key=" + APIKeys.TMDBKEY
        
        AF.request(url, method: .get).validate(statusCode: 200...500).responseJSON { [unowned self] response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                let statusCode = response.response?.statusCode ?? 500

                if 200..<300 ~= statusCode {
                    
                    json["results"].arrayValue.forEach {
                        let title = $0["title"].stringValue
                        let description = $0["overview"].stringValue
                        let releaseDate = $0["release_date"].stringValue
                        let genres = $0["genre_ids"][0].intValue
                        let grade = $0["vote_average"].doubleValue
                        let imageURL = $0["backdrop_path"].stringValue
                        
                        let mediaData = TMDBMedia(title: title, description: description, releaseDate: releaseDate, genres: genres, grade: grade, imageURL: imageURL)
                        mediaDataManager.addData(newData: mediaData)
                    }
                    
                    collectionView.reloadData()
                    
                }else {
                    print("STATUSCODE : \(statusCode)")
                }
                
                
            case .failure(let error):
                print(error)
            }
        }
        
        collectionView.reloadData()
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
