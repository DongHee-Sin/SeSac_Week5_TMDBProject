//
//  SearchResultCollectionViewCell.swift
//  SeSacTMDBProject
//
//  Created by 신동희 on 2022/08/03.
//

import UIKit

class SearchResultCollectionViewCell: UICollectionViewCell {

    static let identifier = String(describing: SearchResultCollectionViewCell.self)
    
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
        descriptionLabel.text = data.description
        if let url = URL(string: EndPoint.TMDBImagePathEndPoint + data.imageURL) {
            loadImage(url: url)
        }
    }
    
    
    func loadImage(url: URL) {
        DispatchQueue.global().async { [unowned self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.posterImage.image = image
                    }
                }
            }
        }
    }
}
