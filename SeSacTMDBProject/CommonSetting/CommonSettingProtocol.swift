//
//  CommonSettingProtocol.swift
//  SeSacTMDBProject
//
//  Created by 신동희 on 2022/08/05.
//

import Foundation


protocol CommonSetting {
    static var identifier: String { get }
    
    func configureInitialUI()
}
