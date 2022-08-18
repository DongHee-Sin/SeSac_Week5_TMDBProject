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
    var isStared: Bool = false
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
    
    private var _interestMovieList: [(Int, String)] = []
    var interestMovieList: [(Int, String)] {
        while _interestMovieList.count < 10 {
            if let media = mediaList.randomElement() { sawMovieInfo(id: media.id, title: media.title) }
        }
        return _interestMovieList
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
    
    func sawMovieInfo(id: Int, title: String) {
        let movieInfo = (id, title)
        
        guard !_interestMovieList.contains(where: { (id, title) in id == movieInfo.0 }) else { return }
        
        if _interestMovieList.count >= 10 {
            _interestMovieList.removeFirst()
        }
        
        _interestMovieList.append(movieInfo)
    }
    
    
    func toggleStar(at index: Int) {
        mediaList[index].isStared.toggle()
    }
}
