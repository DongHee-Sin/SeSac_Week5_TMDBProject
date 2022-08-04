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

    // MARK: - Propertys
    var media: TMDBMedia?
    
    var castList: [CastInfo] = []
    var crewList: [CrewInfo] = []
    
    
    
    // MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!
    
    
    
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
        
        tableView.register(UINib(nibName: "PersonInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "PersonInfoTableViewCell")
        tableView.register(UINib(nibName: "MediaInfoTableViewHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "MediaInfoTableViewHeader")
        
        self.navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.title = "출연/제작"
    }
    
    
    func requestMediaInfo(movieID: Int) {
        let url = EndPoint.MediaInfoEndPoint + "\(movieID)/credits?api_key=\(APIKeys.TMDBKEY)&language=en-US"
        
        AF.request(url, method: .get).validate(statusCode: 200...500).responseData { [unowned self] response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                let statusCode = response.response?.statusCode ?? 500
                
                if 200..<300 ~= statusCode {
                    
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
                    
                    tableView.reloadData()
                    
                }else {
                    print("STATUSCODE : \(statusCode)")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}



// MARK: - TableView Protocol
extension MediaInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else { return nil }
        
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MediaInfoTableViewHeader") as? MediaInfoTableViewHeader else {
            return nil
        }
        
        if let media = media {
            header.updateCell(dy: media)
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return castList.count
        }else if section == 2 {
            return crewList.count
        }else {
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PersonInfoTableViewCell", for: indexPath) as? PersonInfoTableViewCell else {
            return UITableViewCell()
        }
        
        if indexPath.section == 1 {
            cell.updateCell(dy: castList[indexPath.row])
        }else if indexPath.section == 2 {
            cell.updateCell(dy: crewList[indexPath.row])
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Cast"
        }else if section == 2 {
            return "Crew"
        }else {
            return nil
        }
    }
}
