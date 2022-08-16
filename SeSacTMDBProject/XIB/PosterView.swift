//
//  PosterView.swift
//  SeSacTMDBProject
//
//  Created by 신동희 on 2022/08/09.
//

import UIKit

import Kingfisher

class PosterView: UIView {

    @IBOutlet private weak var posterImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = self.frame.height / 20
        self.clipsToBounds = true
        
        posterImage.contentMode = .scaleAspectFill
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        let view = UINib(nibName: "PosterView", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    
    func setImage(url: URL?) {
        posterImage.kf.setImage(with: url, placeholder: UIImage(systemName: "star"))
    }
}
