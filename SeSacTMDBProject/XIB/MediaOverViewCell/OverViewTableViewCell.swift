//
//  OverViewTableViewCell.swift
//  SeSacTMDBProject
//
//  Created by 신동희 on 2022/08/05.
//

import UIKit


protocol OverViewExtensionDelegate {
    func seeMoreButtonTapped()
}


class OverViewTableViewCell: UITableViewCell {

    @IBOutlet weak var seeMoreButton: UIButton!
    @IBOutlet weak var overViewLabel: UILabel!
    
    var delegate: OverViewExtensionDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }
    
    
    func configureShortenUI() {
        overViewLabel.numberOfLines = 2
        seeMoreButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
    }
    
    func configureExpandUI() {
        overViewLabel.numberOfLines = 0
        seeMoreButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
    }
    
    
    func updateCell(overView: String) {
        overViewLabel.text = overView
    }
    
    
    @IBAction func seeMoreButtonTapped(_ sender: UIButton) {
        delegate?.seeMoreButtonTapped()
    }
    
}
