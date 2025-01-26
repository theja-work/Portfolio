//
//  PhotoEditorViewController.swift
//  PlayBox
//
//  Created by Thejas on 26/01/25.
//

import Foundation
import UIKit
import CoreImage

class PhotoEditorViewController: UIViewController {

    var imageView: UIImageView?
    var originalImage: UIImage?
    var context = CIContext()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize the ImageView and Buttons
        DispatchQueue.main.async {
            self.imageView = UIImageView(frame: self.view.bounds)
            self.imageView?.contentMode = .scaleAspectFit
            self.view.addSubview(self.imageView!)

            let editButton = UIButton(frame: CGRect(x: self.view.frame.width / 2 - 50, y: self.view.bounds.height - 120, width: 100, height: 40))
            editButton.setTitle("Apply Filter", for: .normal)
            editButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
            editButton.setTitleColor(UIColor.black, for: .normal)
            editButton.backgroundColor = .systemCyan
            editButton.clipsToBounds = true
            editButton.layer.cornerRadius = 4.0
            editButton.addTarget(self, action: #selector(self.applyFilter), for: .touchUpInside)
            self.view.addSubview(editButton)
        }
    }

    func setupImage(image: UIImage) {
        
        DispatchQueue.main.async {
            self.originalImage = image
            self.imageView?.image = image
            
            self.imageView?.setNeedsLayout()
            self.imageView?.layoutIfNeeded()
            
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }

    @objc func applyFilter() {
        guard let originalImage = originalImage else { return }
        
        // Apply a simple filter
        if let ciImage = CIImage(image: originalImage) {
            let filter = CIFilter(name: "CISepiaTone")
            filter?.setValue(ciImage, forKey: kCIInputImageKey)
            filter?.setValue(0.8, forKey: kCIInputIntensityKey)
            
            if let outputImage = filter?.outputImage {
                let cgImage = context.createCGImage(outputImage, from: outputImage.extent)
                let filteredImage = UIImage(cgImage: cgImage!)
                imageView?.image = filteredImage
            }
        }
    }
}
