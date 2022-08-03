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
        let url = EndPoint.TMDBEndPoint + "movie" + "/" + "week" + "?" + "api_key=" + APIKeys.TMDBKEY
        
        AF.request(url, method: .get).validate(statusCode: 200...500).responseJSON { [unowned self] response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                let statusCode = response.response?.statusCode ?? 500

                
                
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
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    
    func configureCollectionViewLayout(rowCount: CGFloat) -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        
        let sectionSpacing: CGFloat = 8
        let itemSpacing: CGFloat = 20
        
        let width: CGFloat = UIScreen.main.bounds.width - (itemSpacing * (rowCount-1)) - (sectionSpacing * 2)
        let itemWidth: CGFloat = width / rowCount
        
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.2)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing
        
        return layout
    }
}
