//
//  CustomSlider.swift
//  TestAPI
//
//  Created by Saranyu's Macbook Pro on 13/02/24.
//

import Foundation
import UIKit

open class CustomSlider : UISlider {
    
    @IBInspectable var trackHeight: CGFloat = 3
    
    @IBInspectable var thumbRadius: CGFloat = 8
    
    //private var thumbTouchSize = CGSize(width: 40, height: 40)
    
    private lazy var thumbView: UIView = {
        let thumb = UIView()
        thumb.backgroundColor = .white
        thumb.layer.borderWidth = 0.4
        thumb.layer.borderColor = UIColor.white.cgColor
        return thumb
    }()
    
    private func thumbImage(radius: CGFloat) -> UIImage {
        // Set proper frame
        // y: radius / 2 will correctly offset the thumb
        
        thumbView.frame = CGRect(x: 0, y: radius / 2, width: radius, height: radius)
        thumbView.layer.cornerRadius = radius / 2
        
        // Convert thumbView to UIImage
        // See this: https://stackoverflow.com/a/41288197/7235585
        
        let renderer = UIGraphicsImageRenderer(bounds: thumbView.bounds)
        return renderer.image { rendererContext in
            thumbView.layer.render(in: rendererContext.cgContext)
        }
    }
    
    override open func trackRect(forBounds bounds: CGRect) -> CGRect {
        let customBounds = CGRect(x: 0, y: bounds.midY, width: bounds.width, height: 2)
        
        super.trackRect(forBounds: customBounds)
        
        var newRect = super.trackRect(forBounds: bounds)
        newRect.size.height = trackHeight
        
        return customBounds
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        let thumb = thumbImage(radius: thumbRadius)
        //setThumbImage(thumb, for: .normal)
        setThumbImage(thumb, for: .highlighted)
    }
    
    override open func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {

        return true

    }
    
    
}
