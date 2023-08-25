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
    
    @IBOutlet weak var playerViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var playerViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var playButton : HomeButtons!
    
    @IBOutlet weak var backButton : HomeButtons!
    
    @IBOutlet weak var metaDataScrollView: UIScrollView!
    
    @IBOutlet weak var videoTitleLabel: UILabel!
    
    @IBOutlet weak var videoDescriptionLabel: UILabel!
    
    @IBOutlet weak var scrollableContentHeight: NSLayoutConstraint!
    
    @IBOutlet weak var thumbnailDurationLabel: UILabel!
    
    @IBOutlet weak var metaDataHolderView: UIView!
    
    @IBOutlet weak var playerControlsView: UIView!
    
    @IBOutlet weak var seekbarHolderView: UIView!
    
    @IBOutlet weak var playerBackwardButtonHolderView: UIView!
    
    @IBOutlet weak var playerForewardButtonHolderView: UIView!
    
    @IBOutlet weak var playerPlayButtonHolderView: UIView!
    
    @IBOutlet weak var playerBackwardButtonImageview: UIImageView!
    
    @IBOutlet weak var playerPlayButtonImageview: UIImageView!
    
    @IBOutlet weak var playerForwardButtonImageview: UIImageView!
    
    
    var player : AVPlayer? = nil
    var animationCounter = 0
    var loader : UIActivityIndicatorView!
    var topNavBarPlayerOffset = 0.0
    var thumbnailDidTap = false
    var playButtonTap = false
    var backwardButtonTap = false
    var forwardButtonTap = false
    
    var videoItem : VideoItem?
    var viewModel : VideoViewModel?
    
    let playerRotationAnimationKey = "on_rotation_key"
    let playerScaleAnimationKey = "on_scale_key"
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = ColorCodes.SkyBlue.color
        
        guard let navHeight = self.navigationController?.navigationBar.frame.size.height else {return}
        
        topNavBarPlayerOffset = (navHeight - 3) * 2
        
        setupViewModel()
        
        buttonSetup()
        setupLoader()
        playerSetup()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    public func setupViewModel() {
        
        self.viewModel = VideoViewModel(api: VideoServiceAPI())
        
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
            if self.loader.isAnimating , self.loader.isHidden == false {return}
            
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
        
        self.showLoader()
        
        viewModel?.getDataFromServer(responseHandler: { [weak self] dataResponse in
            guard let strongSelf = self else {return}
            
            switch dataResponse {
            case .success(let video) :
                strongSelf.videoItem = video
                strongSelf.setupMetaData()
                strongSelf.setupThumbnail()
                
            case .serverError(let error, let message) :
                print("VideoViewController : Server error with \(error) :: message : \(message)")
                
            case .dataNotFound :
                print("VideoViewController : No data found")
                
            case .networkError :
                print("VideoViewController : network error")
            }
            
        })
        
        setupPlayerControls()
        
        addPlayerObservers()
    }
    
    public func setupPlayerControls() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(updatePlayerControls))
        
        self.playerView.addGestureRecognizer(tap)
        
        
        
        self.playerControlsView.isHidden = true
        //self.playerControlsView.alpha = 0.0
        self.playerControlsView.backgroundColor = .black.withAlphaComponent(0.25)
        
        
        let backwardtap = UITapGestureRecognizer(target: self, action: #selector(backwardPlayerAction))
        let forewardtap = UITapGestureRecognizer(target: self, action: #selector(forwardPlayerAction))
        let playTap = UITapGestureRecognizer(target: self, action: #selector(playerPlayAction))
        
        self.playerBackwardButtonHolderView.addGestureRecognizer(backwardtap)
        self.playerForewardButtonHolderView.addGestureRecognizer(forewardtap)
        self.playerPlayButtonHolderView.addGestureRecognizer(playTap)
        
        DispatchQueue.main.async {
            self.playerBackwardButtonImageview.image = UIImage(named: "player_backward_10_secs")
            self.playerPlayButtonImageview.image = UIImage(named: "player_pause_button")
            self.playerForwardButtonImageview.image = UIImage(named: "player_forward_10_secs")
            
        }
        
    }
    
    @objc func updatePlayerControls() {
        
        if player?.timeControlStatus == .playing {
            
        }
        
        if thumbnailDidTap == false {
            showPlayerControls()
        }
        else {
            hidePlayerControls()
        }
        
        thumbnailDidTap = !thumbnailDidTap
        
        
    }
    
    public func showPlayerControls() {
        print("VideoViewController : show player controls")
        
        //self.view.bringSubviewToFront(playerControlsView)
        self.playerControlsView.alpha = 0.0
        
        UIView.animate(withDuration: 0.6, delay: 0 , options: .curveEaseOut) { [weak self] in
            guard let strongSelf = self else {return}
            
            
            strongSelf.playerControlsView.alpha = 1.0
            strongSelf.seekbarHolderView.alpha = 1.0
            
            //strongSelf.playerControlsView.backgroundColor = UIColor(red: 108, green: 122, blue: 137, alpha: 0.0)
            
            strongSelf.playerControlsView.isHidden = false
            strongSelf.seekbarHolderView.isHidden = false
            
            strongSelf.playerControlsView.isUserInteractionEnabled = true
            
            
        } completion: { finished in
            if finished {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut) {
                        [weak self] in
                            guard let strongSelf = self else {return}
                            
                            strongSelf.seekbarHolderView.alpha = 0.0
                            strongSelf.playerControlsView.alpha = 0.0
                            
                        strongSelf.playerControlsView.backgroundColor = .black.withAlphaComponent(0.25)
                        strongSelf.thumbnailDidTap = !strongSelf.thumbnailDidTap
                        strongSelf.playerControlsView.isUserInteractionEnabled = true
                    }
                })
            }
        }
    }
    
    public func hidePlayerControls() {
        print("VideoViewController : hide player controls")
        
        //self.view.sendSubviewToBack(playerControlsView)
        
        UIView.animate(withDuration: 0.6, delay: 0 , options: .curveEaseOut) { [weak self] in
            guard let strongSelf = self else {return}
            
            strongSelf.seekbarHolderView.alpha = 0.0
            strongSelf.playerControlsView.alpha = 0.0
            
            strongSelf.playerControlsView.backgroundColor = .clear
            
            //strongSelf.playerControlsView.isUserInteractionEnabled = false
            
            strongSelf.thumbnailDidTap = !strongSelf.thumbnailDidTap
            
//            strongSelf.seekbarHolderView.isHidden = true
//            strongSelf.playerControlsView.isHidden = true
            
            
        }

    }
    
    @objc func backwardPlayerAction() {
        print("VideoViewController : backward player action")
        
        //self.player?.currentItem?.seek(to: CMTime(seconds: 10, preferredTimescale: CMTimeScale(1.0)))
    }
    
    @objc func forwardPlayerAction() {
        print("VideoViewController : foreward player action")
        
        //self.player?.currentItem?.seek(to: CMTime(seconds: 100, preferredTimescale: .zero))
    }
    
    @objc func playerPlayAction() {
        print("VideoViewController : player play action")
        
        if playButtonTap == false {
            self.playerPlayButtonImageview.image = UIImage(named: "player_play_button")
            
            if self.player?.timeControlStatus == .playing {
                self.player?.pause()
            }
        }
        else {
            self.playerPlayButtonImageview.image = UIImage(named: "player_pause_button")
            
            self.player?.play()
        }
        
        playButtonTap = !playButtonTap
    }
    
    public func setupMetaData() {
        
        DispatchQueue.main.async {
            self.metaDataHolderView.clipsToBounds = false
            self.metaDataHolderView.layer.masksToBounds = false
            self.metaDataHolderView.layer.cornerRadius = 12
            self.metaDataHolderView.backgroundColor = ColorCodes.BlueGray.color
        }
        
        labelUISetup()
        
        guard let title = self.videoItem?.videoTitle , let description = self.videoItem?.videoDescription else {return}
        
        guard let duration = self.videoItem?.videoDuration else {return}
        
        DispatchQueue.main.async {
            self.videoTitleLabel.text = title
            self.videoDescriptionLabel.text = description
            self.thumbnailDurationLabel.text = duration
            self.thumbnailDurationLabel.layoutSubviews()
        }
        
    }
    
    public func setupThumbnail() {
        
        DispatchQueue.main.async {
            self.playerThumbnailImageview.image = UIImage(named: "placeholder_16x9")
        }
        
        self.showLoader()
        
        guard let video = self.videoItem else {return}
        
        ImagePickerManager.getImageFromUrl(url: video.videoThumbnailUrl, onCompletion: { [weak self] imageResponse in
            
            guard let strongSelf = self else {return}
            
            strongSelf.hideLoader()
            
            switch imageResponse {
                
            case .success(let image) :
                
                DispatchQueue.main.async {
                    strongSelf.playerThumbnailImageview.image = image
                }
                
            case .dataNotFound :
                print("VideoViewController : image not found")
                
            case .serverError(let code, let message) :
                print("VideoViewController : server error with code : \(code) :: message : \(message)")
                
            case .networkError :
                print("VideoViewController : network error")
            }
            
        })
    }
    
    public func labelUISetup() {
        
        
        DispatchQueue.main.async {
            self.videoTitleLabel.font = CustomFont.OS_Bold.font
            self.videoDescriptionLabel.font = CustomFont.OS_Semibold.font
            self.videoDescriptionLabel.numberOfLines = 0
            self.thumbnailDurationLabel.font = UIFont(name: "OpenSans-Regular", size: 5)
            self.thumbnailDurationLabel.backgroundColor = UIColor.darkGray
            self.thumbnailDurationLabel.textColor = .white
            self.thumbnailDurationLabel.clipsToBounds = true
            self.thumbnailDurationLabel.layer.masksToBounds = true
            self.thumbnailDurationLabel.layer.cornerRadius = 6
            self.thumbnailDurationLabel.textAlignment = .center
        }
        
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
                strongSelf.hideMetaData()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    strongSelf.playerView.transform = CGAffineTransform(scaleX: x, y: x)
                })
                
            }
            
        }
        else {
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5) { [weak self] in
                guard let strongSelf = self else {return}
                
                strongSelf.playerPortraitTransition()
                strongSelf.showMetaData()
                
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
    
    public func hideMetaData() {
        self.metaDataScrollView.alpha = 0.0
        self.metaDataScrollView.isUserInteractionEnabled = false
    }
    
    public func showMetaData() {
        self.metaDataScrollView.alpha = 1.0
        self.metaDataScrollView.isUserInteractionEnabled = true
    }
    
    public func buttonSetup() {
        self.playButton.setupStyle(type: .Image)
        self.playButton.setTitle("Play", for: .normal)
        
        self.backButton.setupStyle(type: .Image)
        self.backButton.setTitle("Back", for: .normal)
    }
    
    public func getVideoFromServer() {
        
        self.playerView.backgroundColor = .clear
        
        //let videoURL = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4"
        
        guard let videoURL = self.videoItem?.videoUrl else {return}
        
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
