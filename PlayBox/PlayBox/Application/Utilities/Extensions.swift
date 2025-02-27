//
//  Extensions.swift
//  PlayBox
//
//  Created by Thejas on 25/01/25.
//

import Foundation
import UIKit
import Combine

extension UIImage {
    
    class func getImage(url:String) -> UIImage? {
        
        var image : UIImage?
        
        //let queue = DispatchQueue(label: "image.queue", qos: .userInitiated ,  attributes: .concurrent)
        
        
//        queue.async {
//            
//            let task = URLSession.shared.dataTask(with: URLRequest(url: URL(string: url)!)) { imageData, response, error in
//                
//                if error == nil , let data = imageData {
//                    image = UIImage(data: data)
//                }
//                
//            }
//            
//            task.resume()
//            
//        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: URL(string: url)!)) { imageData, response, error in
            
            if error == nil , let data = imageData {
                image = UIImage(data: data)
            }
            
        }
        
        task.resume()
        
        return image
    }
    
    func imageRotated(by angle: CGFloat) -> UIImage? {
            // Calculate the new size for the rotated image
            let rotatedSize = CGSize(width: self.size.width * abs(cos(angle)) + self.size.height * abs(sin(angle)),
                                     height: self.size.height * abs(cos(angle)) + self.size.width * abs(sin(angle)))
            
            UIGraphicsBeginImageContextWithOptions(rotatedSize, false, self.scale)
            let context = UIGraphicsGetCurrentContext()
            
            // Move the origin to the center of the image to rotate
            context?.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
            context?.rotate(by: angle)
            
            // Draw the rotated image
            self.draw(in: CGRect(x: -self.size.width / 2, y: -self.size.height / 2, width: self.size.width, height: self.size.height))
            
            // Get the new image
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return rotatedImage
        }
    
}

extension UIImageView {
    
    private static var imageCache = NSCache<NSString, UIImage>()
    
    /// Loads an image from the given URL and sets it to the `UIImageView`.
    /// - Parameters:
    ///   - url: The URL to load the image from.
    ///   - placeholder: A placeholder image to display while the image is being loaded.
    func loadImage(from url: URL, placeholder: UIImage? = nil) {
        // Set the placeholder image
        self.image = placeholder
        
        // Check if the image is already cached
        if let cachedImage = UIImageView.imageCache.object(forKey: url.absoluteString as NSString) {
            self.image = cachedImage
            return
        }
        
        // Download the image from the URL
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            
            // Handle errors or invalid data
            if let error = error {
                print("Failed to load image from URL: \(error.localizedDescription)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("Failed to convert data to UIImage.")
                return
            }
            
            // Cache the downloaded image
            UIImageView.imageCache.setObject(image, forKey: url.absoluteString as NSString)
            
            // Update the UIImageView on the main thread
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
    
    
}

class CustomPageControl: UIPageControl {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // Customize the size of the indicators
        for (index, subview) in self.subviews.enumerated() {
            if index == self.currentPage {
                // Current page indicator
                subview.transform = CGAffineTransform(scaleX: 0.8, y: 0.8) // Scale up the current page indicator
            } else {
                // Remaining page indicators
                subview.transform = CGAffineTransform(scaleX: 1.0, y: 1.0) // Default size for remaining indicators
            }
        }
    }
}

// Extension to calculate distance between two points
extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        let dx = self.x - point.x
        let dy = self.y - point.y
        return sqrt(dx * dx + dy * dy)
    }
}
