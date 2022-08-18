//
//  FirstViewController.swift
//  SeSacTMDBProject
//
//  Created by 신동희 on 2022/08/16.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print(#function)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print(#function)
    }
    
    deinit {
        print(#function)
    }
}
