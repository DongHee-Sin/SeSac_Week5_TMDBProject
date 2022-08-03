//
//  TMDBResponseModel.swift
//  SeSacTMDBProject
//
//  Created by 신동희 on 2022/08/03.
//

import Foundation


struct TMDBMedia {
    let title: String
    let description: String
    let releaseDate: String
    let imageURL: String
}



struct TMDBDataManager {
    
    // MARK: - Propertys
    private var mediaList: [TMDBMedia] = []
    
    var count: Int { mediaList.count }
    
    
    
    // MARK: - Methdos
    mutating func replaceData(newDatas: [TMDBMedia]) {
        mediaList = newDatas
    }
    
    mutating func addData(newData: TMDBMedia) {
        mediaList.append(newData)
    }
}
