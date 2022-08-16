//
//  MovieListTableViewCell.swift
//  SeSacTMDBProject
//
//  Created by 신동희 on 2022/08/09.
//

import UIKit

class MovieListTableViewCell: UITableViewCell, CommonSetting {

    static let identifier: String = String(describing: MovieListTableViewCell.self)
    
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureInitialUI()
    }
    
    
    func configureInitialUI() {
        titleLabel.backgroundColor = .clear
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 20, weight: .heavy)
        
        collectionView.backgroundColor = .clear
        collectionView.collectionViewLayout = setCollectionViewLayout()
        collectionView.showsHorizontalScrollIndicator = false
        
        self.backgroundColor = .clear
        self.selectionStyle = .none
    }
    
    
    private func setCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let itemWidth = UIScreen.main.bounds.width * 0.27
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.3)
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        return layout
    }
    
    
    func updateCell(title: String, delegate: MovieListViewController, tag: Int) {
        titleLabel.text = title + " 관련 영화"
        
        collectionView.delegate = delegate
        collectionView.dataSource = delegate
        collectionView.register(UINib(nibName: MovieListCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: MovieListCollectionViewCell.identifier)

        collectionView.tag = tag
        
        collectionView.reloadData()
    }
}
