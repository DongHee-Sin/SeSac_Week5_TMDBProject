//
//  MovieListTableViewCell.swift
//  SeSacTMDBProject
//
//  Created by 신동희 on 2022/08/09.
//

import UIKit

class MovieListTableViewCell: UITableViewCell, CommonSetting {

    static let identifier: String = String(describing: MovieListTableViewCell.self)
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureInitialUI() {
        
    }
}
