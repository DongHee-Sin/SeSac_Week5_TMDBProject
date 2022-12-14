//
//  ThirdViewController.swift
//  SeSacTMDBProject
//
//  Created by 신동희 on 2022/08/16.
//

import UIKit

class ThirdViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(#function)
    }

    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "RootTabBarController") as? UITabBarController else {
            return
        }
        
        UserDefaultManager.shared.isInitial = false
        
        changeRootViewController(to: vc)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print(#function)
    }
    
    
    deinit {
        print(#function)
    }
}
