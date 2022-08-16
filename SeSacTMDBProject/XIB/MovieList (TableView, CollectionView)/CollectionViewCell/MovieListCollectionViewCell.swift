//
//  MovieListCollectionViewCell.swift
//  SeSacTMDBProject
//
//  Created by 신동희 on 2022/08/09.
//

import UIKit

class MovieListCollectionViewCell: UICollectionViewCell, CommonSetting {
    
    static let identifier = String(describing: MovieListCollectionViewCell.self)
    
    @IBOutlet private weak var posterView: PosterView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    func configureInitialUI() {}
    
    
    func setImage(url: URL?) {
        posterView.setImage(url: url)
    }
}
