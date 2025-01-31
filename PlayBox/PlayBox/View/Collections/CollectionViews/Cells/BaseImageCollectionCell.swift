//
//  BaseImageCollectionCell.swift
//  PlayBox
//
//  Created by Thejas on 29/01/25.
//

import Foundation
import UIKit

class BaseImageCollectionCell : UICollectionViewCell {
    
    class func getCellIdentifier() -> String {
        "BaseImageCollectionCell"
    }
    
    class func getNibName() -> String {
        "BaseImageCollectionCell"
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    var imageGradient : CAGradientLayer?
    
    var item : VideoModel?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageGradient?.frame = imageView.bounds
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
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
    
    func setupCell(item:VideoModel) {
        
        DispatchQueue.main.async {
            
            self.imageView.loadImage(from: URL(string: item.thumbnail)!)
            
            self.imageView.contentMode = .scaleToFill
            
            self.imageView.setNeedsLayout()
            self.imageView.layoutIfNeeded()
            
            self.setNeedsLayout()
            self.layoutIfNeeded()
            
        }
        
    }
    
}
