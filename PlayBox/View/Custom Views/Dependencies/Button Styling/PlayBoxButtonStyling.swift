//
//  PlayBoxButtonStyling.swift
//  PlayBox
//
//  Created by Thejas on 27/03/25.
//

import UIKit
import Foundation

class PlayBoxButtonStyling : ButtonStylingDependency {
    
    typealias Component = UIButton
    
    var title: String?
    
    var font: UIFont?
    
    var image: UIImage?
    
    var textColor: UIColor?
    
    var backgroundColor: UIColor?
    
    var cornerRadius: CGFloat?
    
    func setupButton(button: UIButton) {
        
        DispatchQueue.main.async {
            
            button.clipsToBounds = true
            button.layer.masksToBounds = true
            
            button.setTitle(self.title, for: .normal)
            button.setTitleColor(self.textColor, for: .normal)
            //button.titleLabel?.font = self.font
            button.setImage(self.image, for: .normal)
            button.backgroundColor = self.backgroundColor
            button.layer.cornerRadius = self.cornerRadius ?? 0.0
            
            button.setNeedsLayout()
            button.layoutIfNeeded()
        }
        
    }
    
    func buildStyling(title: String, font: UIFont, image: UIImage?, textColor: UIColor?, backgroundColor: UIColor, cornerRadius: CGFloat) {
        
        self.title = title
        self.font = font
        self.image = image
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.textColor = textColor
    }
    
}
