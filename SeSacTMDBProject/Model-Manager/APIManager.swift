//
//  APIManager.swift
//  SeSacTMDBProject
//
//  Created by 신동희 on 2022/08/05.
//

import Foundation

import Alamofire
import SwiftyJSON


class APIManager {
    
    typealias CompletionHandler = (JSON) -> Void
    
    static let shared = APIManager()
    
    private init() {}
    
    
    func requestAPI(url: String, completionHandler: @escaping CompletionHandler) {
        
        AF.request(url, method: .get).validate(statusCode: 200...500).responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)

                let statusCode = response.response?.statusCode ?? 500

                if 200..<300 ~= statusCode {
                    
                    completionHandler(json)
                    
                }else {
                    print("STATUSCODE : \(statusCode)")
                }
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
