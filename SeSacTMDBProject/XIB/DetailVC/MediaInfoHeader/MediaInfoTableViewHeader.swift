//
//  MediaInfoTableViewHeader.swift
//  SeSacTMDBProject
//
//  Created by 신동희 on 2022/08/04.
//

import UIKit

import Kingfisher

class MediaInfoTableViewHeader: UITableViewHeaderFooterView, CommonSetting {
    
    static let identifier: String = String(describing: MediaInfoTableViewHeader.self)

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureInitialUI()
    }
    
    
    func configureInitialUI() {
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        titleLabel.textColor = .white
        titleLabel.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        titleLabel.minimumScaleFactor = 0.7
        
        posterImage.layer.borderColor = UIColor.white.cgColor
        posterImage.layer.borderWidth = 1
        posterImage.contentMode = .scaleAspectFill
        
        backgroundImage.contentMode = .scaleAspectFill
    }
    
    
    func updateCell(dy data: TMDBMedia) {
        let backgroundURL = URL(string: EndPoint.TMDBImagePathEndPoint + data.backgroundImageURL)
        backgroundImage.kf.setImage(with: backgroundURL)
        
        let posterURL = URL(string: EndPoint.TMDBImagePathEndPoint + data.posterImageURL)
        posterImage.kf.setImage(with: posterURL)
        
        titleLabel.text = " \(data.title) "
    }
}

