//
//  Extensions.swift
//  PlayBox
//
//  Created by Thejas on 25/01/25.
//

import Foundation
import UIKit

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
        
        DispatchQueue.global().async {
            
            let task = URLSession.shared.dataTask(with: URLRequest(url: URL(string: url)!)) { imageData, response, error in
                
                if error == nil , let data = imageData {
                    image = UIImage(data: data)
                }
                
            }
            
            task.resume()
            
        }
        
        return image
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

