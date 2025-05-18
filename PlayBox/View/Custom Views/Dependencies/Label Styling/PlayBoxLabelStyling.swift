//
//  PlayBoxLabelStyling.swift
//  PlayBox
//
//  Created by Thejas on 27/03/25.
//

import UIKit

class PlayBoxLabelStyling : LabelStylingDependency {
    
    var title: String?
    
    var font: UIFont?
    
    var textColor: UIColor?
    
    var backGroundColor: UIColor?
    
    var cornerRadius: CGFloat?
    
    var borderThickness: CGFloat?
    
    var borderColor: UIColor?
    
    func setupLabel(label : UILabel) {
        
        DispatchQueue.main.async {
            
            label.clipsToBounds = true
            label.layer.masksToBounds = true
            
            label.text = self.title
            label.font = self.font
            label.textColor = self.textColor
            label.backgroundColor = self.backGroundColor
            label.layer.cornerRadius = self.cornerRadius ?? 0.0
            
            label.setNeedsLayout()
            label.layoutIfNeeded()
        }
        
    }
    
    func buildStyling(title: String, font: UIFont, textColor: UIColor, backGroundColor: UIColor?, cornerRadius: CGFloat?) {
        
        self.title = title
        self.font = font
        self.textColor = textColor
        self.backGroundColor = backGroundColor
        self.cornerRadius = cornerRadius
        
    }
    
}
