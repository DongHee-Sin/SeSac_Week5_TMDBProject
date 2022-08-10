//
//  MovieListCollectionViewCell.swift
//  SeSacTMDBProject
//
//  Created by 신동희 on 2022/08/09.
//

import UIKit

class MovieListCollectionViewCell: UICollectionViewCell, CommonSetting {
    
    static let identifier = String(describing: MovieListCollectionViewCell.self)
    
    @IBOutlet weak var posterView: PosterView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureInitialUI()
    }

    
    func configureInitialUI() {
        posterView.posterImage.contentMode = .scaleAspectFill
    }
}
