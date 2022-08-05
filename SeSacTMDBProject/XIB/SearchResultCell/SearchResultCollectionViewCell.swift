//
//  SearchResultCollectionViewCell.swift
//  SeSacTMDBProject
//
//  Created by 신동희 on 2022/08/03.
//

import UIKit

import Kingfisher


protocol WebViewButtonDelegate {
    func webViewButtonTapped(mediaID: Int)
}


class SearchResultCollectionViewCell: UICollectionViewCell, CommonSetting {

    static let identifier = String(describing: SearchResultCollectionViewCell.self)
    
    var delegate: WebViewButtonDelegate?
    
    // MARK: - Outlet
    @IBOutlet weak var forShadowView: UIView!
    @IBOutlet weak var forRadiusView: UIView!
    
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    
    // MARK: - Awake From Nib
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureInitialUI()
    }

    
    
    // MARK: - Methods
    func configureInitialUI() {
        addShadow(forShadowView, color: UIColor.black.cgColor, width: 2, height: 2, alpha: 0.5, radius: 8)
        forRadiusView.layer.cornerRadius = forRadiusView.frame.height / 20
        forRadiusView.clipsToBounds = true
    }
    
    
    func addShadow(_ to: UIView, color: CGColor, width: CGFloat, height: CGFloat, alpha: Float, radius: CGFloat) {
        to.layer.shadowColor = color
        to.layer.shadowOpacity = alpha
        to.layer.shadowRadius = radius
        to.layer.shadowOffset = CGSize(width: width, height: height)
        to.layer.shadowPath = nil
    }
    
    
    func updateCell(by data: TMDBMedia) {
        titleLabel.text = data.title
        releaseDate.text = data.releaseDate
        let grade = Double(Int(data.grade * 10)) / 10
        gradeLabel.text = "\(grade)"
        genresLabel.text = data.genres
        descriptionLabel.text = data.overView
        let url = URL(string: EndPoint.TMDBImagePathEndPoint + data.backgroundImageURL)
        posterImage.kf.setImage(with: url)
    }
    
    
    
    @IBAction func webViewButtonTapped(_ sender: UIButton) {
        delegate?.webViewButtonTapped(mediaID: 12)
    }
}
