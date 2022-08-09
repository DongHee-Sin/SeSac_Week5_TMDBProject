//
//  MovieListViewController.swift
//  SeSacTMDBProject
//
//  Created by 신동희 on 2022/08/09.
//

import UIKit

class MovieListViewController: UIViewController, CommonSetting {
    
    static let identifier = String(describing: MovieListViewController.self)

    // MARK: - Propertys & Outlet
    @IBOutlet weak var tableView: UITableView!
    
    var someData: [[Int]] = [
        [Int](1...10),
        [Int](2...6),
        [Int](5...10),
        [Int](16...24),
        [Int](6...16)
    ]
    
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: MovieListTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: MovieListTableViewCell.identifier)
    }
    

    
    // MARK: - Methods
    func configureInitialUI() {
        
    }
}



// MARK: - TableView Protocol
extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return someData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return someData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieListTableViewCell.identifier, for: indexPath) as? MovieListTableViewCell else {
            return UITableViewCell()
        }
        
        return cell
    }
}
