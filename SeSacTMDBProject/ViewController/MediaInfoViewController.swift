//
//  TrendingInfoViewController.swift
//  SeSacTMDBProject
//
//  Created by 신동희 on 2022/08/04.
//

import UIKit

import Alamofire
import SwiftyJSON


class MediaInfoViewController: UIViewController {
    
    // MARK: - Propertys & Outlet
    var media: TMDBMedia?
    
    var starButtonActionHandler: (() -> Void)?
    
    private var castList: [CastInfo] = []
    private var crewList: [CrewInfo] = []
    
    private var isOverViewExtended: Bool = false
    
    @IBOutlet private weak var tableView: UITableView!
    
    
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureInitialUI()
        
        if let media = media {
            requestMediaInfo(movieID: media.id)
        }
    }
    
    
    
    // MARK: - Methods
    func configureInitialUI() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: OverViewTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: OverViewTableViewCell.identifier)
        tableView.register(UINib(nibName: PersonInfoTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PersonInfoTableViewCell.identifier)
        tableView.register(UINib(nibName: MediaInfoTableViewHeader.identifier, bundle: nil), forHeaderFooterViewReuseIdentifier: MediaInfoTableViewHeader.identifier)
        
        self.navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.title = "출연/제작"
    }
    
    
    private func requestMediaInfo(movieID: Int) {
        let url = EndPoint.MediaInfoEndPoint + "\(movieID)/credits?api_key=\(APIKeys.TMDBKEY)&language=en-US"
        
        APIManager.shared.requestAPI(url: url) { [unowned self] json in
            json["cast"].arrayValue.forEach {
                let name = $0["name"].stringValue
                let character = $0["character"].stringValue
                let profileURL = $0["profile_path"].string
                
                castList.append(CastInfo(name: name, character: character, profileURL: profileURL))
            }
            
            json["crew"].arrayValue.forEach {
                let name = $0["name"].stringValue
                let department = $0["department"].stringValue
                let profileURL = $0["profile_path"].string
                
                crewList.append(CrewInfo(name: name, department: department, profileURL: profileURL))
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
}



// MARK: - TableView Protocol
extension MediaInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else { return nil }
        
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: MediaInfoTableViewHeader.identifier) as? MediaInfoTableViewHeader else {
            return nil
        }
        
        if let media = media {
            header.updateCell(dy: media)
            header.delegate = self
        }
        
        return header
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return UIScreen.main.bounds.width / 2 * 1.2
        }else {
            return 50
        }
    }
    
    
    
    // Cell
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        }else if section == 2 {
            return castList.count
        }else if section == 3 {
            return crewList.count
        }else {
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OverViewTableViewCell.identifier, for: indexPath) as? OverViewTableViewCell else {
                return UITableViewCell()
            }
            
            if let media = media {
                cell.updateCell(overView: media.overView)
            }
            
            if isOverViewExtended {
                cell.configureExpandUI()
            }else {
                cell.configureShortenUI()
            }
            
            cell.setDelegate(delegate: self)
            
            return cell
        }else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PersonInfoTableViewCell.identifier, for: indexPath) as? PersonInfoTableViewCell else {
                return UITableViewCell()
            }
            
            if indexPath.section == 2 {
                cell.updateCell(dy: castList[indexPath.row])
            }else if indexPath.section == 3 {
                cell.updateCell(dy: crewList[indexPath.row])
            }
            
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return UITableView.automaticDimension
        }else {
            return 100
        }
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "OverView"
        }else if section == 2 {
            return "Cast"
        }else if section == 3 {
            return "Crew"
        }else {
            return nil
        }
    }
}



// MARK: - Custom Protocol
extension MediaInfoViewController: OverViewExtensionDelegate {
    func seeMoreButtonTapped() {
        isOverViewExtended.toggle()
        tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .fade)
    }
}



extension MediaInfoViewController: StarButtonDelegate {
    func starButtonTapped() {
        starButtonActionHandler?()
    }
}
