//
//  Movie.swift
//  tvOS Popular TV
//
//  Created by durul dalkanat on 11/28/15.
//  Copyright © 2015 durul dalkanat. All rights reserved.
//

import Foundation

class Movie {
    
    let BASE_URL = "http://image.tmdb.org/t/p/w500"
    
    var title: String!
    var overview: String!
    var posterPath: String!
    
    init(movieDict: Dictionary<String, AnyObject>) {
        if let title = movieDict["title"] as? String {
            self.title = title
        }
        if let overview = movieDict["overview"] as? String {
            self.overview = overview
        }
        if let path = movieDict["poster_path"] as? String {
            self.posterPath = "\(BASE_URL)\(path)"
            //print(posterPath)
        }
    }
}
