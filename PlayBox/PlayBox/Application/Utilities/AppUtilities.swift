//
//  AppUtilities.swift
//  PlayBox
//
//  Created by Thejas on 12/02/25.
//

import Foundation
import UIKit

final class AppUtilities {
    
    static let shared = AppUtilities()
    
    private init(){}
    
    func log(_ message: String,
             file: String = #file,
             function: String = #function,
             line: Int = #line) {
        let fileName = (file as NSString).lastPathComponent
        print("[\(fileName):\(function)] \(line) - \(message)")
    }
    
    func removeBlackPadding(from image: UIImage) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        
        let ciImage = CIImage(cgImage: cgImage)
        let context = CIContext(options: nil)
        
        // Convert image to grayscale
        let grayscale = ciImage.applyingFilter("CIColorControls", parameters: [kCIInputSaturationKey: 0])
        
        // Apply edge detection to find the actual content
        let edges = grayscale.applyingFilter("CIEdges", parameters: [kCIInputIntensityKey: 10])
        
        // Convert processed image back to CGImage
        guard let outputCGImage = context.createCGImage(edges, from: edges.extent) else { return nil }
        
        let outputUIImage = UIImage(cgImage: outputCGImage)
        
        // Detect the bounding box of non-black pixels
        let boundingBox = detectBoundingBox(in: outputUIImage)
        
        
        if let croppedCgImage = cgImage.cropping(to: boundingBox) {
            return UIImage(cgImage: croppedCgImage)
        }
        
        return nil
    }

    // Helper function to detect the bounding box of non-black pixels
    private func detectBoundingBox(in image: UIImage) -> CGRect {
        guard let cgImage = image.cgImage else { return .zero }

        let width = cgImage.width
        let height = cgImage.height

        guard let pixelData = cgImage.dataProvider?.data else { return .zero }
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)

        var minY = height, maxY = 0

        // Define a threshold for what counts as "black"
        let blackThreshold: CGFloat = 0.05 // Adjust between 0.0 (pure black) to 1.0

        func isBlackPixel(_ pixelIndex: Int) -> Bool {
            let red = CGFloat(data[pixelIndex]) / 255.0
            let green = CGFloat(data[pixelIndex + 1]) / 255.0
            let blue = CGFloat(data[pixelIndex + 2]) / 255.0

            return red < blackThreshold && green < blackThreshold && blue < blackThreshold
        }

        for y in 0..<height {
            var rowHasContent = false
            for x in 0..<width {
                let pixelIndex = (y * width + x) * 4
                if !isBlackPixel(pixelIndex) {
                    rowHasContent = true
                    minY = min(minY, y)
                    maxY = max(maxY, y)
                }
            }
            if rowHasContent { break } // Stop early if content is found
        }

        for y in stride(from: height - 1, through: 0, by: -1) {
            var rowHasContent = false
            for x in 0..<width {
                let pixelIndex = (y * width + x) * 4
                if !isBlackPixel(pixelIndex) {
                    rowHasContent = true
                    minY = min(minY, y)
                    maxY = max(maxY, y)
                }
            }
            if rowHasContent { break } // Stop early if content is found
        }

        let newHeight = maxY - minY
        return CGRect(x: 0, y: minY + 2, width: width, height: newHeight)
    }
    
}

class Logger {
    
    class func log(_ message: String,
             file: String = #file,
             function: String = #function,
             line: Int = #line) {
        let fileName = (file as NSString).lastPathComponent
        print("[\(fileName):\(function)] \(line) - \(message)")
    }
    
}
