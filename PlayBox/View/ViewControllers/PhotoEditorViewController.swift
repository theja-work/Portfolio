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
    var editButton : UIButton?
    
    var filterApplied : Bool = false
    weak var editingDelegate : PhotoEditingProtocol?
    
    init(editingDelegate: PhotoEditingProtocol? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.editingDelegate = editingDelegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize the ImageView and Buttons
        DispatchQueue.main.async {
            self.imageView = UIImageView(frame: self.view.bounds)
            self.imageView?.contentMode = .scaleAspectFit
            self.view.addSubview(self.imageView!)

            self.editButton = UIButton(frame: CGRect(x: self.view.frame.width / 2 - 50, y: self.view.bounds.height - 120, width: 100, height: 40))
            !self.filterApplied ? self.editButton?.setTitle("Apply Filter", for: .normal) : self.editButton?.setTitle("Apply Filter", for: .normal)
            self.editButton?.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
            self.editButton?.setTitleColor(UIColor.black, for: .normal)
            self.editButton?.backgroundColor = .systemCyan
            self.editButton?.clipsToBounds = true
            self.editButton?.layer.cornerRadius = 4.0
            self.editButton?.addTarget(self, action: #selector(self.applyFilter), for: .touchUpInside)
            self.view.addSubview(self.editButton!)
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
            filter?.setValue(0.6, forKey: kCIInputIntensityKey)
            
            if let outputImage = filter?.outputImage {
                let cgImage = context.createCGImage(outputImage, from: outputImage.extent)
                let filteredImage = UIImage(cgImage: cgImage!)
                imageView?.image = filteredImage
                
                DispatchQueue.main.async {
                    
                    !self.filterApplied ? self.editButton?.setTitle("Save changes", for: .normal) : self.editButton?.setTitle("Apply Filter", for: .normal)
                    
                    self.filterApplied = !self.filterApplied
                    
                    if self.filterApplied {
                        return
                    }
                    else {
                        self.editingDelegate?.applyFilter(image: filteredImage)
                        self.dismiss(animated: true)
                    }
                    
                }
            }
        }
        
    }
}

protocol PhotoEditingProtocol : AnyObject {
    func applyFilter(image:UIImage)
    func removeFilter(image:UIImage)
}
