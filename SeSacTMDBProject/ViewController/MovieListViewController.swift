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
        
        configureInitialUI()
    }
    

    
    // MARK: - Methods
    func configureInitialUI() {
        view.backgroundColor = .black
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
    }
}



// MARK: - TableView Protocol
extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return someData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieListTableViewCell.identifier, for: indexPath) as? MovieListTableViewCell else {
            return UITableViewCell()
        }
        
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        cell.collectionView.register(UINib(nibName: MovieListCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: MovieListCollectionViewCell.identifier)

        cell.collectionView.tag = indexPath.section
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.width * 0.5
    }
}



// MARK: - CollectionView Protocol
extension MovieListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return someData[collectionView.tag].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListCollectionViewCell.identifier, for: indexPath) as? MovieListCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.posterView.titleLabel.text = "\(someData[collectionView.tag][indexPath.row])"
        
        return cell
    }
}
