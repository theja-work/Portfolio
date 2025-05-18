//
//  CircularGradientButton.swift
//  PlayBox
//
//  Created by Thejas on 28/02/25.
//

import Foundation
import UIKit

class CircularGradientButton: UIButton {
    
    private let borderWidth: CGFloat = 10.0 // Adjust for thickness
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    private func setupButton() {
        self.layer.cornerRadius = self.bounds.width / 2
        self.layer.masksToBounds = false
        
        applyRadialGradientBorder()
        applyInnerShadow()
        applyOuterShadow()
    }
    
    private func applyRadialGradientBorder() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds//.insetBy(dx: -borderWidth, dy: -borderWidth) // Expand gradient size
        gradientLayer.colors = [
            UIColor.systemTeal.cgColor,
            UIColor.black.cgColor
        ]
        gradientLayer.locations = [0.0, 1.0] // Smooth transition
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.opacity = 0.4
        gradientLayer.type = .radial

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(ovalIn: bounds).cgPath
        shapeLayer.lineWidth = borderWidth
        shapeLayer.strokeColor = UIColor.systemTeal.cgColor
        shapeLayer.fillColor = UIColor.black.cgColor

        self.layer.addSublayer(gradientLayer) // Add gradient first
        //gradientLayer.mask = shapeLayer // Then apply masking
    }
    
    private func applyOuterShadow() {
        self.layer.shadowColor = UIColor.red.cgColor
        //self.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.layer.shadowRadius = 16
        self.layer.shadowOpacity = 0.75
    }
    
    private func applyInnerShadow() {
        let innerShadowLayer = CAShapeLayer()
        let path = UIBezierPath(ovalIn: bounds.insetBy(dx: -borderWidth, dy: -borderWidth))
        let cutoutPath = UIBezierPath(ovalIn: bounds)
        path.append(cutoutPath)
        path.usesEvenOddFillRule = true

        innerShadowLayer.path = path.cgPath
        innerShadowLayer.fillRule = .evenOdd
        innerShadowLayer.shadowColor = UIColor.black.cgColor
        //innerShadowLayer.shadowOffset = CGSize(width: 6, height: 6)
        innerShadowLayer.shadowRadius = 24
        innerShadowLayer.shadowOpacity = 0.6
        self.layer.addSublayer(innerShadowLayer)
    }
}
