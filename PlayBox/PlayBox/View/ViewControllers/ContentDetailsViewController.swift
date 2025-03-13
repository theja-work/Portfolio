//
//  ContentDetailsViewController.swift
//  PlayBox
//
//  Created by Thejas on 09/03/25.
//

import Foundation
import UIKit

class ContentDetailsViewController : UIViewController {
    
    class func navigationController(item : VideoItem) -> UINavigationController? {
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        guard let navigationController = storyboard.instantiateViewController(withIdentifier: "CDNC") as? UINavigationController else {return nil}
        
        guard let viewController = navigationController.viewControllers.first as? ContentDetailsViewController else {return nil}
        
        viewController.video = item
        
        return navigationController
    }
    
    class func viewController(item : VideoItem) -> ContentDetailsViewController? {
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "CDVC") as? ContentDetailsViewController else {return nil}
        
        viewController.video = item
        
        return viewController
    }
    
    @IBOutlet weak var contentDetailsImageView: UIImageView!
    
    
    private var video : VideoItem?
    
    private var viewModel : ContentDetailsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        
        setupViewModel()
        viewModel?.loadImage()
    }
    
    func setupViewModel() {
        
        guard let item = video else {return}
        
        viewModel = ContentDetailsViewModel(dataDelegate: self, video: item)
    }
}

extension ContentDetailsViewController : ContentDetailsViewUpdateDelegate {
    
    func updateImage(image: UIImage?) {
        
        guard let image = image else {
            Logger.log("Setup placeholder image")
            return
        }
        
        DispatchQueue.main.async {
            
            self.contentDetailsImageView.image = image
            self.contentDetailsImageView.contentMode = .scaleToFill
            self.contentDetailsImageView.setNeedsLayout()
            self.contentDetailsImageView.layoutIfNeeded()
            
        }
        
    }
    
}
