//
//  UserDefaultsManager.swift
//  SeSacTMDBProject
//
//  Created by 신동희 on 2022/08/16.
//

import Foundation


@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: self.key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: self.key)
        }
    }
}


class UserDefaultManager {
    static let shared = UserDefaultManager()
    
    private init() {}
    
    @UserDefault(key: "isInitial", defaultValue: true)
    var isInitial: Bool
}
