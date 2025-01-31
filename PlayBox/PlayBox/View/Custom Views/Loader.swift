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
    private var superView : UIView?
    
    var isAnimating : Bool {
        
        
        false
    }
    
    var stopLoader : Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        layer.cornerRadius = 8
        backgroundColor = UIColor(red: 1.0, green: 0.6, blue: 0.2, alpha: 1.0)
        addPaths()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        clipsToBounds = true
        layer.cornerRadius = 8
        backgroundColor = UIColor(red: 1.0, green: 0.6, blue: 0.2, alpha: 1.0)
        addPaths()
    }
    
    func addLoader(view:UIView) {
        self.superView = view
        self.center = view.center
        view.addSubview(self)
    }
    
    func removeLoader() {
        
        guard let view = self.superView else {return}
        
        if view.subviews.contains(self) {
            self.removeFromSuperview()
        }
    }
    
    // Add paths to be animated
    func addPaths() {
        
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
            shapeLayer.lineWidth = 1.2
            shapeLayer.strokeEnd = 1.0 // Start with no stroke visible
            layer.addSublayer(shapeLayer)
            shapeLayers.append(shapeLayer)
        }
    }
    
    // Animate the drawing of lines
    func showLoader() {
        
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [self] timer in
            
            startAnimating()
            
            if stopLoader {
                timer.invalidate()
                removeLoader()
            }
            
        }
        
    }
    
    func startAnimating() {
        for (index, shapeLayer) in shapeLayers.enumerated() {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.toValue = 1
            animation.duration = 1.0 // Duration of each line's animation
            animation.beginTime = CACurrentMediaTime() + Double(index) * animation.duration
            animation.fillMode = .forwards
            animation.isRemovedOnCompletion = false
            shapeLayer.add(animation, forKey: "drawLine")
        }
    }
    
    func stopAnimating() {
        stopLoader = true
        
    }
}
