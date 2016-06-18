//
//  MovieCell.swift
//  tvOS Popular TV
//
//  Created by durul dalkanat on 11/28/15.
//  Copyright © 2015 durul dalkanat. All rights reserved.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    @IBOutlet weak var movieImg: UIImageView!
    @IBOutlet weak var movieLbl: UILabel!
    var overview: String!
    
    func configureCell(movie: Movie) {
        if let title = movie.title {
            movieLbl.text = title
        }
        if let overview = movie.overview {
            self.overview = overview
        }
        if let path = movie.posterPath {
            if let url = NSURL(string: path) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    if let data = NSData(contentsOfURL: url) {
                        dispatch_async(dispatch_get_main_queue()) {
                            let img = UIImage(data: data)
                            self.movieImg.image = img
                        }
                    }
                }
            }
            
        }
    }
}