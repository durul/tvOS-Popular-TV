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
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.tvImg!.tintColor = UIColor.darkGray()
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
            self.tvImg!.tintColor = UIColor.lightGray()
            
        } else {
            self.tvImg!.tintColor = UIColor.darkGray()
        }
   }      
        
    func configureCell(_ tv: Tv) {
        if let title = tv.name {
            tvLbl.text = title
        }
        
        if let overview = tv.overview {
            self.overview = overview
        }
        
        //tvOS Popular Tv Shows Image Focus Source

        if let path = tv.posterPath {
            if let url = URL(string: path) {
                DispatchQueue.global(attributes: DispatchQueue.GlobalAttributes.qosDefault).async {
                    if let data = try? Data(contentsOf: url) {
                        DispatchQueue.main.async {
                            let img = UIImage(data: data)
                            self.tvImg.image = img
                        }
                    }
                }
            }
            
        }
    }
}
