//
//  Loader.swift
//  PlayBox
//
//  Created by Thejas on 12/01/25.
//

import Foundation
import UIKit

class Loader : UIView {
    
    private var shapeLayers: [CAShapeLayer] = []
    
    private var timer : Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        layer.cornerRadius = self.bounds.width * 0.25
        //backgroundColor = UIColor(red: 1.0, green: 0.6, blue: 0.2, alpha: 1.0)
        addPaths()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        clipsToBounds = true
        layer.cornerRadius = self.bounds.width * 0.25
        //backgroundColor = UIColor(red: 1.0, green: 0.6, blue: 0.2, alpha: 1.0)
        addPaths()
    }
    
    func addLoader(view:UIView) {
        self.center = view.center
        view.addSubview(self)
        self.isHidden = true
    }
    
    // Add paths to be animated
    private func addPaths() {
        
        let circlePos = self.bounds.width * 0.2
        let circleSize = self.bounds.width * 0.6
        let circlePath = UIBezierPath(ovalIn: CGRect(x: circlePos, y: circlePos, width: circleSize, height: circleSize))
        
        let trianglePath = UIBezierPath()
        let topX = self.bounds.width * 0.4
        let topY = self.bounds.width * 0.35
        let midY = self.bounds.width * 0.65
        let botY = self.bounds.width * 0.5
        
        trianglePath.move(to: CGPoint(x: topX, y: topY)) // Top vertex
        trianglePath.addLine(to: CGPoint(x: topX, y: midY)) // Bottom-left vertex
        trianglePath.addLine(to: CGPoint(x: midY, y: botY)) // Bottom-right vertex
        trianglePath.close() // Close the triangle
        
        let paths = [circlePath, trianglePath]
        
        for path in paths {
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.strokeColor = UIColor.black.cgColor
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.lineWidth = 1.8
            shapeLayer.strokeEnd = 1.0 // Start with no stroke visible
            layer.addSublayer(shapeLayer)
            shapeLayers.append(shapeLayer)
        }
        
        setBackground()
    }
    
    private func setBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [
            UIColor.systemTeal.cgColor,
            UIColor.systemOrange.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.type = .axial

        layer.insertSublayer(gradientLayer, at: 0)
    }

    
    func showLoader() {
        
        guard timer == nil else {return}
        
        DispatchQueue.main.async {
            self.isHidden = false
        }
        
        animate()
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] timer in
            
            guard let strongSelf = self else {return}
            
            strongSelf.animate()
        }
        
    }
    
    func hideLoader() {
        
        DispatchQueue.main.async {
            self.isHidden = true
        }
        
        timer?.invalidate()
        timer = nil 
    }
    
    private func animate() {
        
        DispatchQueue.main.async {
            
            for (index, shapeLayer) in self.shapeLayers.enumerated() {
                let animation = index == 0 ? CABasicAnimation(keyPath: "strokeEnd") : CABasicAnimation(keyPath: "strokeStart")
                animation.fromValue = 0
                animation.toValue = 1
                animation.duration = index == 0 ? 1.0 : 0.64
                animation.beginTime = CACurrentMediaTime() + Double(index) * animation.duration
                animation.fillMode = .forwards
                animation.autoreverses = true
                animation.isRemovedOnCompletion = index == 0 ? true : false
                animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                animation.repeatCount = Float.infinity
                shapeLayer.add(animation, forKey: "drawLine")
            }
        }
        
    }
    
    deinit {
        timer?.invalidate()
        timer = nil 
    }
    
}
