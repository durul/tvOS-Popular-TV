//
//  TVCell.swift
//  tvOS Popular TV
//
//  Created by durul dalkanat on 11/28/15.
//  Copyright © 2015 durul dalkanat. All rights reserved.
//

import UIKit

class TVCell: UICollectionViewCell {
    
    @IBOutlet weak var tvImg: UIImageView!
    @IBOutlet weak var tvLbl: UILabel!
    var overview: String!
    
    func configureCell(tv: Tv) {
        if let title = tv.name {
            tvLbl.text = title
        }
        if let overview = tv.overview {
            self.overview = overview
        }
        if let path = tv.posterPath {
            if let url = NSURL(string: path) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    if let data = NSData(contentsOfURL: url) {
                        dispatch_async(dispatch_get_main_queue()) {
                            let img = UIImage(data: data)
                            self.tvImg.image = img
                        }
                    }
                }
            }
            
        }
    }
}
