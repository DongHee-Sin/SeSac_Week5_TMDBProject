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
    let genres: String
    let grade: Double
    let imageURL: String
}



struct TMDBDataManager {
    
    // MARK: - Propertys
    private var mediaList: [TMDBMedia] = []
    
    private var genresDictionary: [Int: String] = [:]
    
    var count: Int { mediaList.count }
    
    
    
    // MARK: - Methdos    
    mutating func addMediaData(newData: TMDBMedia) {
        mediaList.append(newData)
    }
    
    func getMediaData(at index: Int) -> TMDBMedia {
        return mediaList[index]
    }
    
    mutating func addGenres(key: Int, genre: String) {
        genresDictionary[key] = genre
    }
    
    func getGenres(key: Int) -> String {
        return genresDictionary[key] ?? ""
    }
}
