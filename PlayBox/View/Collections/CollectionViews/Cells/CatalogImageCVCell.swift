//
//  CatalogImageCVCell.swift
//  PlayBox
//
//  Created by Thejas on 11/02/25.
//

import Foundation
import UIKit
import CoreImage

class CatalogImageCVCell : BaseImageCollectionCell {
    
    override class func getNibName() -> String {
        "CatalogImageCVCell"
    }
    
    override class func getCellIdentifier() -> String {
        "CatalogImageCVCell"
    }
    
    override func setupGradient() {
        imageGradient = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        //self.layer.cornerRadius = 32
    }
    
    private static let imageCache : NSCache<NSString,UIImage> = {
        
        let cache = NSCache<NSString,UIImage>()
        cache.countLimit = 100
        cache.totalCostLimit = 200 * 1024 * 1024
        
        return cache
    }()
    
    override func setupCell(item: VideoItem) {
        
        let key = NSString(string: item.thumbnail)
        
        self.imageView.image = nil
        
        loader.showLoader()
        if let image = CatalogImageCVCell.imageCache.object(forKey: key) {
            
            loader.hideLoader()
            
            Logger.log("Using cache for setting image")
            setupImage(image: image)
            
        }
        else {
            
            Service.getImageFrom(url: item.thumbnail) { [weak self] image in
                guard let strongSelf = self else {return}
                
                if let cropped = AppUtilities.shared.removeBlackPadding(from: image) {
                    
                    CatalogImageCVCell.imageCache.setObject(cropped, forKey: key)
                    
                    strongSelf.loader.hideLoader()
                    
                    strongSelf.setupImage(image: cropped)
                }
                
            }
            
        }
    }
    
    override func setupImage(image:UIImage) {
        
        DispatchQueue.main.async {
            
            self.imageView.image = image
            self.imageView.clipsToBounds = true
            self.imageView.layer.masksToBounds = true
            self.imageView.layer.cornerRadius = 12
            
            self.imageView.contentMode = .scaleToFill
            
            self.imageView.setNeedsLayout()
            self.imageView.layoutIfNeeded()
            
            self.setNeedsLayout()
            self.layoutIfNeeded()
            
        }
        
    }

}
