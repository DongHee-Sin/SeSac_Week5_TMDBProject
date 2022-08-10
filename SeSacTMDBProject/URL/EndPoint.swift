//
//  EndPoint.swift
//  SeSacTMDBProject
//
//  Created by 신동희 on 2022/08/03.
//

import Foundation

struct EndPoint {
    
    private static let commonEndPoint = "https://api.themoviedb.org/3/"
    
    static let TMDBImagePathEndPoint = "https://image.tmdb.org/t/p/w500"
    
    static let TMDBEndPoint = "\(commonEndPoint)trending/"
    
    static let GenreURL = "\(commonEndPoint)genre/movie/list?api_key=\(APIKeys.TMDBKEY)&language=en-US"
    
    static let MediaInfoEndPoint = "\(commonEndPoint)movie/"
    
    static let webViewRequestEndpoint = "\(commonEndPoint)movie/"
    
    static let youtubeEndPoint = "https://www.youtube.com/watch?v="
    
    static let recommendMovieEndPoint = "\(commonEndPoint)movie/"
    
    private init() {}
}
