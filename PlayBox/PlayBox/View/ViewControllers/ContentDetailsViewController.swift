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
    
    @IBOutlet weak var playerView: PlayerHolderView!
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .landscape
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        .portrait
    }
    
    private var video : VideoItem?
    
    private var viewModel : ContentDetailsViewModel?
    
    private let playerRotationAnimationKey = "on_rotation_key"
    private let playerScaleAnimationKey = "on_scale_key"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNeedsUpdateOfSupportedInterfaceOrientations()
        setupViewModel()
        setupPlayerView()
        viewModel?.loadImage()
    }
    
    func setupViewModel() {
        
        guard let item = video else {return}
        
        viewModel = ContentDetailsViewModel(dataDelegate: self, video: item)
    }
    
    func setupPlayerView() {
        playerView?.setupPlayerDelegate(delegate: self)
        playerView?.loader.shadeAffect = true
        playerView?.loader.setNeedsLayout()
        playerView?.loader.layoutIfNeeded()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if UIDevice.current.orientation.isLandscape {
            landScapeTransition()
            Logger.log("\(UIDevice.current.orientation.isLandscape)")
        }
        else {
            Logger.log("\(UIDevice.current.orientation.isLandscape)")
            portraitTransition()
        }
    }
    
    
    
    private func landScapeTransition() {
        let x = 16.0/9.0
        
        playerLandscapeTransition()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.playerView.transform = CGAffineTransform(scaleX: x, y: x)
        })
    }
    
    private func portraitTransition() {
        
        playerPortraitTransition()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            
            self.playerView.transform = .identity
        })
        
    }
    
    private func playerLandscapeTransition() {
        if self.playerView.layer.animation(forKey: playerRotationAnimationKey) == nil {
            let animation = CABasicAnimation(keyPath: "transform.rotation.z")
            animation.fromValue = 0
            animation.toValue = CGFloat.pi / 30
            animation.duration = 0.1
            self.playerView.layer.add(animation, forKey: playerRotationAnimationKey)
        }
        
        if self.playerView.layer.animation(forKey: playerScaleAnimationKey) == nil {
            let animation = CABasicAnimation(keyPath: "transform.scale")
            animation.fromValue = 1
            animation.toValue = 2
            animation.duration = 0.2
            self.playerView.layer.add(animation, forKey: playerScaleAnimationKey)
        }
    }
    
    private func playerPortraitTransition() {
        if self.playerView.layer.animation(forKey: playerRotationAnimationKey) == nil {
            let animation = CABasicAnimation(keyPath: "transform.rotation.z")
            animation.fromValue = 0
            animation.toValue = -CGFloat.pi / 30
            animation.duration = 0.2
            self.playerView.layer.add(animation, forKey: playerRotationAnimationKey)
        }
        
        if self.playerView.layer.animation(forKey: playerScaleAnimationKey) == nil {
            let animation = CABasicAnimation(keyPath: "transform.scale")
            animation.fromValue = 2
            animation.toValue = 1
            animation.duration = 0.3
            self.playerView.layer.add(animation, forKey: playerScaleAnimationKey)
        }
    }
}

extension ContentDetailsViewController : ContentDetailsViewUpdateDelegate {
    
    func updateImage(image: UIImage?) {
        
        guard let image = image else {
            Logger.log("Setup placeholder image")
            return
        }
        
        DispatchQueue.main.async {
            
            self.playerView?.thumbnailImageView?.image = AppUtilities.shared.removeBlackPadding(from: image)
            self.playerView?.thumbnailImageView?.contentMode = .scaleToFill
            self.playerView?.thumbnailImageView?.setNeedsLayout()
            self.playerView?.thumbnailImageView?.layoutIfNeeded()
            
        }
        
    }
    
    func updateLoader(isLoading: Bool) {
        isLoading ? playerView?.loader.showLoader() : playerView?.loader.hideLoader()
        
        playerView?.loader.setNeedsLayout()
        playerView?.loader.layoutIfNeeded()
    }
    
}

extension ContentDetailsViewController : PlayerHolderDelegate {
    
    func showThumbnail() {
        
    }
    
    func closePlayer() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func loadNext() {
        
    }
    
    func loadPrevious() {
        
    }
    
}
