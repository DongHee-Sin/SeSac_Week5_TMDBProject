//
//  MovieListCollectionViewCell.swift
//  SeSacTMDBProject
//
//  Created by 신동희 on 2022/08/09.
//

import UIKit

class MovieListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var posterView: PosterView!


    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setImage(url: URL?) {
        posterView.setImage(url: url)
    }
}



class testCell: UICollectionViewCell {
    
}
