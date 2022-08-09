//
//  EndPoint.swift
//  SeSacTMDBProject
//
//  Created by 신동희 on 2022/08/03.
//

import Foundation

struct EndPoint {
    
    static let TMDBImagePathEndPoint = "https://image.tmdb.org/t/p/w500"
    
    static let TMDBEndPoint = "https://api.themoviedb.org/3/trending/"
    
    static let GenreURL = "https://api.themoviedb.org/3/genre/movie/list?api_key=\(APIKeys.TMDBKEY)&language=en-US"
    
    static let MediaInfoEndPoint = "https://api.themoviedb.org/3/movie/"
    
    static let webViewRequestEndpoint = "https://api.themoviedb.org/3/movie/"
    
    static let youtubeEndPoint = "https://www.youtube.com/watch?v="
    
    private init() {}
}
