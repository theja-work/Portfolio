//
//  ButtonStylingDependency.swift
//  PlayBox
//
//  Created by Thejas on 27/03/25.
//

import UIKit

protocol ButtonStylingDependency : AnyObject {
    
    associatedtype Component : UIView
    
    var title : String? {get set}
    var font : UIFont? {get set}
    var image : UIImage? {get set}
    var textColor : UIColor? {get set}
    var backgroundColor : UIColor? {get set}
    var cornerRadius : CGFloat? {get set}
    
    func setupButton(button : Component)
    func buildStyling(title:String,font:UIFont,image:UIImage?,textColor : UIColor?,backgroundColor:UIColor,cornerRadius:CGFloat)
}

extension ButtonStylingDependency where Self : UIView {
    
    func setButtonBorderProperties(borderColor:UIColor,borderThinckness:CGFloat) {
        
        guard let button = self as? Component else {return}
        
        button.clipsToBounds = true
        button.layer.masksToBounds = true
        
        DispatchQueue.main.async {
            button.layer.borderColor = borderColor.cgColor
            button.layer.borderWidth = borderThinckness
            
            button.setNeedsLayout()
            button.layoutIfNeeded()
        }
        
    }
    
    func setButtonGradient(colors:[UIColor]) {
        
        guard let button = self as? Component else {return}
        
        button.clipsToBounds = true
        button.layer.masksToBounds = true
        
        let gradient = CAGradientLayer()
        
        gradient.colors = colors
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.frame = button.bounds
        gradient.type = .axial
        
        DispatchQueue.main.async {
            button.layer.insertSublayer(gradient, at: 0)
            button.setNeedsLayout()
            button.layoutIfNeeded()
        }
        
    }
}
