//
//  BaseImageCollectionCell.swift
//  PlayBox
//
//  Created by Thejas on 29/01/25.
//

import Foundation
import UIKit
import Combine

class BaseImageCollectionCell : UICollectionViewCell {
    
    class func getCellIdentifier() -> String {
        "BaseImageCollectionCell"
    }
    
    class func getNibName() -> String {
        "BaseImageCollectionCell"
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var loader: Loader!
    
    var imageGradient : CAGradientLayer?
    
    var item : VideoItem?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageGradient?.frame = imageView.bounds
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupGradient()
        loader.skin = .CellImage
    }
    
    private static let imageCache : NSCache<NSString,UIImage> = {
        
        let cache = NSCache<NSString,UIImage>()
        cache.countLimit = 100
        cache.totalCostLimit = 200 * 1024 * 1024
        
        return cache
    }()
    
    func setupCell(item:VideoItem) {
        
        let key = NSString(string: item.thumbnail)
        
        self.imageView.image = nil
        
        loader.showLoader()
        
        if let image = BaseImageCollectionCell.imageCache.object(forKey: key) {
            loader.hideLoader()
            setupImage(image: image)
        }
        else {
            
            Service.getImageFrom(url: item.thumbnail) { [weak self] image in
                
                guard let self = self else {return}
                
                self.loader.hideLoader()
                
                self.setupImage(image: image)
                
            }
            
        }
        
    }
    
    func setupImage(image:UIImage) {
        
        DispatchQueue.main.async {
            
            self.imageView.image = image
            
            self.imageView.contentMode = .scaleToFill
            
            self.imageView.setNeedsLayout()
            self.imageView.layoutIfNeeded()
            
            self.setNeedsLayout()
            self.layoutIfNeeded()
            
        }
        
    }
    
    func setupGradient() {
        
        guard imageGradient == nil else {return}
        
        imageGradient = CAGradientLayer()
        imageGradient?.colors = [UIColor.black.cgColor , UIColor.clear.cgColor]
        imageGradient?.startPoint = CGPoint(x: 0.6, y: 1)
        imageGradient?.endPoint = CGPoint(x: 0.6, y: 0)
        imageGradient?.locations = [0.15 , 0.6]
        imageGradient?.frame = imageView.bounds
        
        DispatchQueue.main.async {
            self.imageView.layer.addSublayer(self.imageGradient!)
        }
    }
    
}
