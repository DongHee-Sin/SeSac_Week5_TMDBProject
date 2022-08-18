//
//  MediaInfoTableViewHeader.swift
//  SeSacTMDBProject
//
//  Created by 신동희 on 2022/08/04.
//

import UIKit

import Kingfisher
import SeSacTMDBFrameWork



protocol StarButtonDelegate {
    func starButtonTapped()
}



class MediaInfoTableViewHeader: UITableViewHeaderFooterView, ReusableProtocol {

    static var identifier: String { return String(describing: self) }
    
    var isStared: Bool = false
    
    var delegate: StarButtonDelegate?
    
    @IBOutlet private weak var backgroundImage: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var posterImage: UIImageView!
    @IBOutlet weak var starButton: UIButton!
    
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
        
        isStared = data.isStared
        updateStar()
    }
    
    
    private func updateStar() {
        if isStared {
            starButton.tintColor = .yellow
        }else {
            starButton.tintColor = .darkGray
        }
    }
    
    
    @IBAction private func starButtonTapped(_ sender: UIButton) {
        delegate?.starButtonTapped()
        
        isStared.toggle()
        updateStar()
    }
    
}

