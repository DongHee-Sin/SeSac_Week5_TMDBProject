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
    private var searchResultList: [TMDBMedia] = []
    
    private var genresDictionary: [Int: String] = [:]
    
    var count: Int {
        return searchWord == "" ? mediaList.count : searchResultList.count
    }
    
    var searchWord: String = "" {
        didSet {
            if searchWord != "" {
                searchResultList = mediaList.filter { $0.title == searchWord }
            }else {
                searchResultList.removeAll()
            }
        }
    }
    
    
    
    // MARK: - Methdos    
    mutating func addMediaData(newData: TMDBMedia) {
        mediaList.append(newData)
    }
    
    func getMediaData(at index: Int) -> TMDBMedia {
        guard index < mediaList.count else { return TMDBMedia(id: 0, title: "", overView: "", releaseDate: "", genres: "", grade: 0, backgroundImageURL: "", posterImageURL: "") }
        
        if searchWord == "" {
            return mediaList[index]
        }else {
            return searchResultList[index]
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
