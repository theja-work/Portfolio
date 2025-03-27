//
//  UIDependency.swift
//  PlayBox
//
//  Created by Thejas on 27/03/25.
//

import UIKit

// handle errors and testing dependencies later
protocol LabelStylingDependency : AnyObject {
    
    associatedtype Component : UIView
    
    var title : String? {get set}
    var font : UIFont? {get set}
    var textColor : UIColor? {get set}
    var backGroundColor : UIColor? {get set}
    var cornerRadius : CGFloat? {get set}
    
    func setupLabel(label : Component)
    func buildStyling(title:String,font:UIFont,textColor:UIColor,backGroundColor: UIColor?,cornerRadius: CGFloat?)
}

extension LabelStylingDependency where Self: UIView {
    
    func applyBorderStyling(borderThickness: CGFloat? = nil, borderColor: UIColor? = nil) {
        
        guard let view = self as? Component else { return }
        
        if let borderThickness = borderThickness , let borderColor = borderColor {
            DispatchQueue.main.async {
                
                view.clipsToBounds = true
                view.layer.masksToBounds = true
                
                view.layer.borderWidth = borderThickness
                view.layer.borderColor = borderColor.cgColor
                
                view.setNeedsLayout()
                view.layoutIfNeeded()
            }
        }
        
    }
    
    func applyGradientStyling(colors:[UIColor]) {
        
        guard let view = self as? Component else { return }
        
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        
        let layer = CAGradientLayer()
        
        layer.colors = colors
        layer.startPoint = CGPoint(x: 0, y: 1)
        layer.endPoint = CGPoint(x: 1, y: 1)
        layer.type = .axial
        layer.frame = view.bounds
        
        DispatchQueue.main.async {
            view.layer.insertSublayer(layer, at: 0)
            
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
        
    }
}
