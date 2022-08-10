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



class TMDBDataManager {
    
    static let shared = TMDBDataManager()
    private init() {}
    
    // MARK: - Propertys
    private var mediaList: [TMDBMedia] = [] {
        didSet { updateSearchResultList() }
    }
    private var searchResultList: [TMDBMedia] = []
    
    private var genresDictionary: [Int: String] = [:]
    
    var count: Int {
        return searchWord == "" ? mediaList.count : searchResultList.count
    }
    
    var searchWord: String = "" {
        didSet { updateSearchResultList() }
    }
    
    var sawMovies: [Int: String] = [:] {
        didSet {
            if sawMovies.count > 7 {
                sawMovies[sawMovies.keys.randomElement()!] = nil
            }
        }
    }
    var interestMovieList: [Int: String] {
        if sawMovies.count == 7 { return sawMovies }

        var resultDic = sawMovies
        while resultDic.count < 7 {
            if let media = mediaList.randomElement() { resultDic[media.id] = media.title }
        }
        return resultDic
    }
    
    
    
    // MARK: - Methdos    
    func addMediaData(newData: TMDBMedia) {
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
    
    func addGenres(key: Int, genre: String) {
        genresDictionary[key] = genre
    }
    
    func getGenres(key: Int) -> String {
        return genresDictionary[key] ?? ""
    }
    
    func removeAllData() {
        mediaList.removeAll()
    }
    
    func updateSearchResultList() {
        if searchWord != "" {
            searchResultList = mediaList.filter { $0.title.lowercased().contains(searchWord.lowercased()) }
        }else {
            searchResultList.removeAll()
        }
    }
}
