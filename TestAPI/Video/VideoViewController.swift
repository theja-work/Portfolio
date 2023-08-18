//
//  VideoViewController.swift
//  TestAPI
//
//  Created by Thejas K on 16/08/23.
//

import Foundation
import UIKit
import CoreData
import AVFoundation

public class VideoViewController : UIViewController {
    
    public class func viewController() -> VideoViewController {
        
        let storyBoard = UIStoryboard(name: "VideoViewController", bundle: nil)
        
        let viewController = storyBoard.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
        
        
        return viewController
    }
    @IBOutlet weak var playerThumbnailImageview: UIImageView!
    
    @IBOutlet weak var playerView : UIView!
    
    @IBOutlet weak var playerViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var playerViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var playerViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var playButton : HomeButtons!
    
    @IBOutlet weak var backButton : HomeButtons!
    
    var player : AVPlayer? = nil
    var animationCounter = 0
    var loader : UIActivityIndicatorView!
    var topNavBarPlayerOffset = 0.0
    
    let playerRotationAnimationKey = "on_rotation_key"
    let playerScaleAnimationKey = "on_scale_key"
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = ColorCodes.SkyBlue.color
        
        guard let navHeight = self.navigationController?.navigationBar.frame.size.height else {return}
        
        topNavBarPlayerOffset = (navHeight - 3) * 2
        
        buttonSetup()
        setupLoader()
        playerSetup()
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
//        if self.playerView.layer.animation(forKey: "onRotation") == nil {
//            let animation = CABasicAnimation(keyPath: "transform.rotation.z")
//            animation.fromValue = NSNumber.FloatLiteralType(floatLiteral: 0.0)
//            animation.toValue = NSNumber.FloatLiteralType(floatLiteral:CGFloat.pi / 2)
//            animation.duration = 2.0
//            animation.delegate = self
//            //animation.repeatCount = Float(CGFloat.infinity)
//            self.playerView.layer.add(animation, forKey: "onRotation")
//        }
        
    }
    
    public func setupLoader() {
        self.loader = UIActivityIndicatorView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 60, height: 60)))
        
        loader.style = .medium
        loader.color = ColorCodes.SkyBlue.color
        loader.backgroundColor = .clear
        
        self.playerView.addSubview(loader)
        loader.center = self.playerView.center
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.centerYAnchor.constraint(equalTo: playerView.centerYAnchor).isActive = true
        loader.centerXAnchor.constraint(equalTo: playerView.centerXAnchor).isActive = true
        
    }
    
    public func showLoader() {
        DispatchQueue.main.async {
            self.view.bringSubviewToFront(self.loader)
            self.playerView.bringSubviewToFront(self.loader)
            self.loader.isHidden = false
            self.loader.startAnimating()
        }
    }
    
    public func hideLoader() {
        DispatchQueue.main.async {
            self.view.sendSubviewToBack(self.loader)
            self.playerView.sendSubviewToBack(self.loader)
            self.loader.isHidden = true
            self.loader.stopAnimating()
        }
    }
    
    public func playerSetup() {
        //self.playerView.translatesAutoresizingMaskIntoConstraints = false
        let imageUrl = "https://i.ytimg.com/vi/aqz-KE-bpKQ/maxresdefault.jpg"
        
        var request = URLRequest(url: URL(string: imageUrl)!)
        
        self.showLoader()
        
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) {[weak self] imageData, response, requestError in
            guard let strongSelf = self else {return}
            
            strongSelf.hideLoader()
            
            if requestError == nil , imageData != nil {
                
                if let data = imageData , let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        strongSelf.playerThumbnailImageview.image = image
                    }
                    //strongSelf.showThumbnail()
                }
                
            }
            
        }
        
        task.resume()
        
        addPlayerObservers()
    }
    
    public func addPlayerObservers() {
        
        
        
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        guard topNavBarPlayerOffset != 0 else {return}
        
        if UIDevice.current.orientation.isLandscape {
            self.navigationController?.isNavigationBarHidden = true

            self.animationCounter = 1
            
            playerViewTopConstraint.constant = topNavBarPlayerOffset//82
            
            hidePlayerBoundButton()
            
            
        } else {
            self.navigationController?.isNavigationBarHidden = false

            self.animationCounter = 0
            
            playerViewTopConstraint.constant = 0
            
            showPlayerBoundButton()
            
        }
        
        if animationCounter == 1 {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5) { [weak self] in
                guard let strongSelf = self else {return}
                
                let x = 16.0/9.0
                
                strongSelf.playerLandscapeTransition()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    strongSelf.playerView.transform = CGAffineTransform(scaleX: x, y: x)
                })
                
            }
            
        }
        else {
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5) { [weak self] in
                guard let strongSelf = self else {return}
                
                strongSelf.playerPortraitTransition()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    
                    strongSelf.playerView.transform = .identity
                })
                
            }
            
        }
    }
    
    public func playerLandscapeTransition() {
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
    
    public func playerPortraitTransition() {
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
    
    public func buttonSetup() {
        self.playButton.setupStyle(type: .Video)
        self.playButton.setTitle("Play", for: .normal)
        
        self.backButton.setupStyle(type: .Video)
        self.backButton.setTitle("Back", for: .normal)
    }
    
    public func getVideoFromServer() {
        
        self.playerView.backgroundColor = .clear
        
        //let videoURL = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4"
        
        let videoURL = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
        
        let url = URL(string: videoURL)!
        
        let playerItem = AVPlayerItem(url: url)
        
        if self.player != nil {return}
        
        self.player = AVPlayer(playerItem: playerItem)
        
        let playerLayer = AVPlayerLayer(player: self.player)
        
        playerLayer.frame = self.playerView.bounds
        playerLayer.backgroundColor = UIColor.clear.cgColor
        
        playerLayer.videoGravity = .resizeAspect
        self.playerView.layer.addSublayer(playerLayer)
        
    }
    
    @IBAction func playButtonAction(_ sender : HomeButtons) {
        
        
        self.getVideoFromServer()
        
        DispatchQueue.main.async {
            self.player?.play()
        }
        
        //self.playButton.isHidden = true
    }
    
    public func hideThumbnail() {
        DispatchQueue.main.async {
            self.view.sendSubviewToBack(self.playerThumbnailImageview)
            self.playerThumbnailImageview.isHidden = true
        }
    }
    
    public func showThumbnail() {
        DispatchQueue.main.async {
            self.view.bringSubviewToFront(self.playerThumbnailImageview)
            self.playerThumbnailImageview.isHidden = false
        }
    }
    
    @IBAction func backButtonAction(_ sender : HomeButtons) {
        
        self.player?.pause()
        
        self.player = nil
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc func hidePlayerBoundButton() {
        self.playButton.isHidden = true
        self.backButton.isHidden = true
        self.playButton.isUserInteractionEnabled = false
        self.backButton.isUserInteractionEnabled = false
    }
    
    @objc func showPlayerBoundButton() {
        self.playButton.isHidden = false
        self.backButton.isHidden = false
        self.playButton.isUserInteractionEnabled = true
        self.backButton.isUserInteractionEnabled = true
    }
    
}
