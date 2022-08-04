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
    
    var castList: [PersonInfo] = []
    var crewList: [PersonInfo] = []
    
    
    
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
            header.updateCell(data: media)
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UIScreen.main.bounds.width / 2 * 1.2
    }
    
    
    
    // Cell
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return castList.count
        }else if section == 1 {
            return crewList.count
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PersonInfoTableViewCell", for: indexPath) as? PersonInfoTableViewCell else {
            return UITableViewCell()
        }
        
        return cell
    }
}
