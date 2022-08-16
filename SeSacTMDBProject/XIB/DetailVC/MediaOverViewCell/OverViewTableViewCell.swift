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


class OverViewTableViewCell: UITableViewCell, CommonSetting {

    static let identifier: String = String(describing: OverViewTableViewCell.self)
    
    @IBOutlet private weak var seeMoreButton: UIButton!
    @IBOutlet private weak var overViewLabel: UILabel!
    
    private var delegate: OverViewExtensionDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureInitialUI()
    }
    
    
    func configureInitialUI() {
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
    
    
    func setDelegate(delegate: OverViewExtensionDelegate) {
        self.delegate = delegate
    }
    
    
    @IBAction private func seeMoreButtonTapped(_ sender: UIButton) {
        delegate?.seeMoreButtonTapped()
    }
    
}
