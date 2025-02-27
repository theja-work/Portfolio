//
//  CustomSlider.swift
//  PlayBox
//
//  Created by Thejas on 25/02/25.
//

import Foundation
import UIKit

class CustomSlider: UISlider {
    // Define the curve properties
    private let curveRadius: CGFloat = 135 // Radius of the curve
    private let thumbSize: CGFloat = 30.0 // Size of the thumb
    var isSliding = false
    private var initialTouchLocation: CGPoint?
    private var isTapped = false
    private var lastValue : Float = 0
    private var thumbTapGesture: UITapGestureRecognizer?
    private let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    private var lastHapticValue: Float = 0
    private let thumbImage = UIImage(named: "sliderPointer")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSlider()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSlider()
    }
    
    private func setupSlider() {
        self.isContinuous = true // Ensure continuous
        
        self.setThumbImage(thumbImage, for: .normal)
        
        addTapHandling()
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        // Adjust the track width for vertical orientation
        var rect = super.trackRect(forBounds: bounds)
        rect.size.width = 0 // Set the width of the track
        return rect
    }
    
    private func rotateThumbRect(imageRect: CGRect, angle: CGFloat) {
        // Rotate the thumb image based on the angle
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // Save the current context state
        context.saveGState()
        
        // Move the context's origin to the thumb's center
        context.translateBy(x: imageRect.midX, y: imageRect.midY)
        
        // Rotate the context
        context.rotate(by: angle)
        
        // Draw the image rotated at the center of the thumb rect
        thumbImage?.draw(in: CGRect(x: -thumbSize / 2, y: -thumbSize / 2, width: thumbSize, height: thumbSize))
        
        // Restore the context state
        context.restoreGState()
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        // Define the curve path for vertical orientation
        let centerX = bounds.midX
        let startY = bounds.minY + thumbSize / 2
        let endY = bounds.maxY - thumbSize / 2

        let midX = bounds.midX
        let midY = bounds.midY

        let path = UIBezierPath()
        path.move(to: CGPoint(x: centerX, y: startY))
        path.addArc(withCenter: CGPoint(x: midX, y: midY), radius: curveRadius, startAngle: -CGFloat.pi / 2, endAngle: CGFloat.pi / 2, clockwise: true)

        // Customize the track color
        context.setStrokeColor(UIColor.clear.cgColor)
        context.setLineWidth(0)
        
        // Add the path and apply the shadow
        context.addPath(path.cgPath)
        context.strokePath()
    }
    
    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        
        let buttonRadius = bounds.width / 2  // Radius of the circular button
        let adjustedRadius = buttonRadius - (thumbSize / 2) + 12 // Stay within button edges
        
        let centerX = bounds.midX
        let centerY = bounds.midY
        
        // Calculate the normalized value (0 to 1)
        let percent = CGFloat(value - minimumValue) / CGFloat(maximumValue - minimumValue)
        
        // Convert percent into an angle (-π to π)
        let angle = -CGFloat.pi + (2 * CGFloat.pi * percent)
        
        // Compute new x, y positions along the edge of the button
        let x = centerX + adjustedRadius * cos(angle)
        let y = centerY + adjustedRadius * sin(angle)
        
        let thumbX = x - (thumbSize / 2) + 2
        let thumbY = y - (thumbSize / 2)
        
        let thumbRect = CGRect(x: thumbX, y: thumbY, width: thumbSize, height: thumbSize)
        rotateThumbRect(imageRect: thumbRect, angle: angle)
        
        let thumbImageRotated = thumbImage?.withAlignmentRectInsets(UIEdgeInsets(top: -thumbSize / 2, left: -thumbSize / 2, bottom: thumbSize / 2, right: thumbSize / 2)).imageRotated(by: angle)
        
        // Set the rotated thumb image to the slider
        DispatchQueue.main.async {
            self.setThumbImage(thumbImageRotated, for: .normal)
        }

        return CGRect(x: thumbX, y: thumbY, width: thumbSize, height: thumbSize)
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        initialTouchLocation = touch.location(in: self)
        
        impactFeedbackGenerator.prepare()
        isTapped = true
        let thumbRect = self.thumbRect(forBounds: bounds, trackRect: trackRect(forBounds: bounds), value: value)
        if thumbRect.contains(location) {
            return super.beginTracking(touch, with: event)
        }
        isSliding = true
        return false
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        isSliding = false // Sliding stopped
        
        if let initialLocation = initialTouchLocation {
            let finalLocation = touch?.location(in: self) ?? CGPoint.zero
            let distance = initialLocation.distance(to: finalLocation)
            
            // If the distance is small, treat it as a tap and prevent resetting to zero
            if distance < 10 {  // You can adjust the threshold (10) as needed
                // Do not reset to zero in case of a tap
                initialTouchLocation = nil  // Reset the initial tap location
                super.endTracking(touch, with: event)
                return
            }
        }
        
        // Reset thumb position when sliding stops
        if value == minimumValue {
            self.setValue(0, animated: true)  // Reset value to exactly zero
        }
        
        lastValue = self.value
        initialTouchLocation = nil
        
        super.endTracking(touch, with: event)
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        let location = touch.location(in: self)
        let centerX = bounds.midX
        let centerY = bounds.midY
        
        if let initialLocation = initialTouchLocation {
            let distance = initialLocation.distance(to: location)
            
            // If the distance is greater than a threshold, treat it as a slide
            if distance > 2 {
                isTapped = false // It's no longer a tap, it's a slide
            }
        }
        
        // Update the value normally if it's a slide
        if !isTapped {
            
            //let percent = (location.y - thumbSize / 2) / (bounds.height - thumbSize) // for half circle
            let rawPercent = (atan2(location.y - centerY, location.x - centerX) + CGFloat.pi) / (2 * CGFloat.pi) // for full circle

            // Apply a sensitivity factor
            let sensitivityFactor: CGFloat = 2.0 // Increase movement speed
            let adjustedPercent = pow(rawPercent, sensitivityFactor) // Non-linear scaling
            let newValue = Float(adjustedPercent) * (maximumValue - minimumValue) + minimumValue
            
            if shouldTriggerHapticFeedback(for: newValue) {
                if newValue != lastHapticValue { // Prevent triggering haptic feedback repeatedly for the same value
                    impactFeedbackGenerator.impactOccurred()
                    lastHapticValue = newValue
                }
            }
            
            self.value = newValue
            sendActions(for: .valueChanged)
            isSliding = true
        }
        
        return true
    }
    
    private func shouldTriggerHapticFeedback(for value: Float) -> Bool {
        
        return Int(value) % Int(1.5) == 0 // Example condition (every 1 units)
    }
    
    func addTapHandling() {
        
        thumbTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSliderTap(_:)))
        self.addGestureRecognizer(thumbTapGesture!)
        
    }
    
    @objc private func handleThumbTap(_ gesture: UITapGestureRecognizer) {
        // If the user taps on the thumb, prevent resetting it to zero
        isTapped = true
    }
    
    @objc func handleSliderTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self)
        let centerX = bounds.midX
        let centerY = bounds.midY

        // Compute angle relative to center
        let dx = location.x - centerX
        let dy = location.y - centerY
        let tapAngle = atan2(dy, dx) // Radians (-π to π)

        // Map angle to normalized slider range [0,1]
        //let normalizedValue = (tapAngle + CGFloat.pi / 2) / CGFloat.pi // for half circle
        let normalizedValue = (tapAngle + CGFloat.pi) / (2 * CGFloat.pi) // Normalize for full range
        let clampedValue = max(0, min(1, normalizedValue))
        
        // Convert to slider value range
        let newValue = Float(clampedValue) * (self.maximumValue - self.minimumValue) + self.minimumValue
        
        let isChanged = abs(lastValue - newValue) != 0
        
        print(newValue)
        print(isChanged)
        
        if abs(self.value - newValue) > 0.001 && isChanged {
            
            self.setValue(newValue, animated: false)
        }
    }

}
