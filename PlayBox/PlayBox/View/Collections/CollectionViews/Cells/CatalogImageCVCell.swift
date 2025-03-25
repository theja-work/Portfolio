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
    
    override func setupCell(item: VideoItem) {
        //super.setupCell(item: item)
        
        Service.getImageFrom(url: item.thumbnail) { [weak self] image in
            guard let strongSelf = self else {return}
            
            DispatchQueue.main.async {
                
                if let cropped = AppUtilities.shared.removeBlackPadding(from: image) {
                    
                    strongSelf.imageView.image = cropped
                    strongSelf.imageView.clipsToBounds = true
                    strongSelf.imageView.layer.masksToBounds = true
                    strongSelf.imageView.layer.cornerRadius = 12
                }
                
            }
            
        }
    }
    
    

}
