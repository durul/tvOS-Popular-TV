//
//  TV.swift
//  tvOS Popular TV
//
//  Created by durul dalkanat on 11/28/15.
//  Copyright © 2015 durul dalkanat. All rights reserved.
//

import Foundation

import Foundation

class Tv {
    
    let BASE_URL = "http://image.tmdb.org/t/p/w500"
    
    var name: String!
    var overview: String!
    var posterPath: String!
    
    init(tvshowsDict: Dictionary<String, AnyObject>) {
        if let name = tvshowsDict["name"] as? String {
            self.name = name
        }
        if let overview = tvshowsDict["overview"] as? String {
            self.overview = overview
        }
        if let path = tvshowsDict["poster_path"] as? String {
            self.posterPath = "\(BASE_URL)\(path)"
            //print(posterPath)
        }
    }
}
