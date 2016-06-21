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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.movieImg!.tintColor = UIColor.darkGray()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        // Is userInterfaceStyle available ?
        
        guard (traitCollection.responds(to: #selector(getter: UITraitCollection.userInterfaceStyle))) else {  return  }
        
        // Did the userIntarfaceStyle change ?
        
        guard (traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle) else {
            return
        }
        
        if traitCollection.userInterfaceStyle == .dark {
            self.movieImg!.tintColor = UIColor.lightGray()

        } else {
            self.movieImg!.tintColor = UIColor.darkGray()
        }
        
    }
    
    func configureCell(_ movie: Movie) {
        if let title = movie.title {
            movieLbl.text = title
        }
        if let overview = movie.overview {
            self.overview = overview
        }
        if let path = movie.posterPath {
            if let url = URL(string: path) {
                DispatchQueue.global(attributes: DispatchQueue.GlobalAttributes.qosDefault).async {
                    if let data = try? Data(contentsOf: url) {
                        DispatchQueue.main.async {
                            let img = UIImage(data: data)
                            self.movieImg.image = img
                        }
                    }
                }
            }
            
        }
    }
}
