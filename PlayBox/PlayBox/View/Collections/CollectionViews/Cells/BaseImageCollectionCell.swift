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
    
    var imageGradient : CAGradientLayer?
    
    var item : VideoItem?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageGradient?.frame = imageView.bounds
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupGradient()
    }
    
    func setupCell(item:VideoItem) {
        
        DispatchQueue.main.async {
            
            self.imageView.loadImage(from: URL(string: item.thumbnail)!)
            
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
