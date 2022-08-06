//
//  TMDBResponseModel.swift
//  SeSacTMDBProject
//
//  Created by 신동희 on 2022/08/03.
//

import Foundation


struct TMDBMedia {
    let id: Int
    let title: String
    let overView: String
    let releaseDate: String
    let genres: String
    let grade: Double
    let backgroundImageURL: String
    let posterImageURL: String
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
    
    func getMediaData(at index: Int, searchWord: String) -> TMDBMedia {
        guard index < mediaList.count else { return TMDBMedia(id: 0, title: "", overView: "", releaseDate: "", genres: "", grade: 0, backgroundImageURL: "", posterImageURL: "") }
        
        if searchWord == "" {
            return mediaList[index]
        }else {
            return mediaList.filter { $0.title == searchWord }[index]
        }
    }
    
    func getMediaDataCount(searchWord: String) -> Int {
        if searchWord == "" {
            return mediaList.count
        }else {
            return mediaList.filter { $0.title == searchWord }.count
        }
    }
    
    mutating func addGenres(key: Int, genre: String) {
        genresDictionary[key] = genre
    }
    
    func getGenres(key: Int) -> String {
        return genresDictionary[key] ?? ""
    }
    
    
    mutating func removeAllData() {
        mediaList.removeAll()
    }
}
