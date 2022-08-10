//
//  PersonInfoTableViewCell.swift
//  SeSacTMDBProject
//
//  Created by 신동희 on 2022/08/04.
//

import UIKit

import Kingfisher

class PersonInfoTableViewCell: UITableViewCell, CommonSetting {
    
    static let identifier: String = String(describing: PersonInfoTableViewCell.self)

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailInfoLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureInitialUI()
    }    
    
    
    // MARK: - Methdos
    func configureInitialUI() {
        profileImage.layer.cornerRadius = profileImage.frame.height / 8
        
        self.selectionStyle = .none
    }
    
    func updateCell(dy data: CastInfo) {
        if let profileURLString = data.profileURL {
            let profileURL = URL(string: EndPoint.TMDBImagePathEndPoint + profileURLString)
            profileImage.kf.setImage(with: profileURL)
        }else {
            profileImage.tintColor = .darkGray
            profileImage.image = UIImage(systemName: "person.fill")
        }
        nameLabel.text = data.name
        detailInfoLabel.text = data.character
    }
    
    func updateCell(dy data: CrewInfo) {
        if let profileURLString = data.profileURL {
            let profileURL = URL(string: EndPoint.TMDBImagePathEndPoint + profileURLString)
            profileImage.kf.setImage(with: profileURL)
        }else {
            profileImage.tintColor = .darkGray
            profileImage.image = UIImage(systemName: "person.fill")
        }
        nameLabel.text = data.name
        detailInfoLabel.text = data.department
    }
}
