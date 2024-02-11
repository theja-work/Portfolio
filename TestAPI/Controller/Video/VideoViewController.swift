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
import TestSDK

public class VideoViewController : BaseViewController {
    
    public class func viewController() -> VideoViewController {
        
        let storyBoard = UIStoryboard(name: "VideoViewController", bundle: nil)
        
        let viewController = storyBoard.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
        
        
        return viewController
    }
    
    var testSDK : TestSDKFrameWork?
    
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
    
    @IBOutlet weak var playerProgressView: UIProgressView!
    
    @IBOutlet weak var remainingTimeLabel: UILabel!
    
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    
    
    public var progressUpdateTimer : Timer?
    
    var player : AVPlayer? = nil
    var animationCounter = 0
    var playerLoader : UIActivityIndicatorView!
    var topNavBarPlayerOffset = 0.0
    var thumbnailDidTap = false
    var playButtonTap = false
    var backwardButtonTap = false
    var forwardButtonTap = false
    var controlFadeSeconds = 0.9
    
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
        
        testSDKmethod()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AppOrientation.lockOrientation(.all)
    }
    
    func testSDKmethod() {
        testSDK = TestSDKFrameWork()
        
        testSDK?.setBackgroundColor(forView: self.view, color: ColorCodes.BlueGray.color)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        self.player?.pause()
        
        self.player = nil
    }
    
    public func setupViewModel() {
        
        self.viewModel = VideoViewModel(api: VideoServiceAPI())
        
    }
    
    public func setupLoader() {
        self.playerLoader = UIActivityIndicatorView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 60, height: 60)))
        
        playerLoader.style = .medium
        playerLoader.color = ColorCodes.SkyBlue.color
        playerLoader.backgroundColor = .clear
        
        self.playerView.addSubview(playerLoader)
        playerLoader.center = self.playerView.center
        playerLoader.translatesAutoresizingMaskIntoConstraints = false
        playerLoader.centerYAnchor.constraint(equalTo: playerView.centerYAnchor).isActive = true
        playerLoader.centerXAnchor.constraint(equalTo: playerView.centerXAnchor).isActive = true
        
    }
    
    public func showLoader() {
        DispatchQueue.main.async {
            if self.playerLoader.isAnimating , self.playerLoader.isHidden == false {return}
            
            self.view.bringSubviewToFront(self.playerLoader)
            self.playerView.bringSubviewToFront(self.playerLoader)
            self.playerLoader.isHidden = false
            self.playerLoader.startAnimating()
        }
    }
    
    public func hideLoader() {
        DispatchQueue.main.async {
            self.view.sendSubviewToBack(self.playerLoader)
            self.playerView.sendSubviewToBack(self.playerLoader)
            self.playerLoader.isHidden = true
            self.playerLoader.stopAnimating()
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
        
        self.progressUpdateTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateProgressBar), userInfo: nil, repeats: true)
        
        self.playerForewardButtonHolderView.layer.masksToBounds = true
        self.playerBackwardButtonHolderView.layer.masksToBounds = true
        self.playerPlayButtonHolderView.layer.masksToBounds = true
        
        self.playerForewardButtonHolderView.layer.cornerRadius = 8.0
        self.playerBackwardButtonHolderView.layer.cornerRadius = 8.0
        self.playerPlayButtonHolderView.layer.cornerRadius = 8.0
        
        DispatchQueue.main.async {
            self.playerBackwardButtonImageview.image = UIImage(named: "player_backward_secs")
            self.playerPlayButtonImageview.image = UIImage(named: "player_pause_button")
            self.playerForwardButtonImageview.image = UIImage(named: "player_forward_secs")
            
            self.playerBackwardButtonImageview.tintColor = ColorCodes.turmeric.color
            self.playerForwardButtonImageview.tintColor = ColorCodes.turmeric.color
            self.playerPlayButtonImageview.tintColor = ColorCodes.turmeric.color
            
            self.playerProgressView.progressTintColor = ColorCodes.turmeric.color
            self.playerProgressView.progress = 0.0
            
            self.playerForewardButtonHolderView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self.playerBackwardButtonHolderView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self.playerPlayButtonHolderView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self.seekbarHolderView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            
        }
        
    }
    
    @objc func updateProgressBar() {
        
        guard let position = self.player?.currentItem?.currentTime().seconds else {return}
        guard let duration = self.player?.currentItem?.duration.seconds else {return}
        
        let elapsedTimeString = formatSecondsToString(position)
        
        if self.player?.currentItem?.isPlaybackLikelyToKeepUp == true {
            print("VideoViewController : playing :\(elapsedTimeString)")
            
            DispatchQueue.main.async {
                self.playerProgressView.setProgress(Float(position / 1000), animated: true)
                self.playerProgressView.setNeedsLayout()
                self.playerProgressView.layoutIfNeeded()
            }
        }
        
        self.elapsedTimeLabel.text = "\(elapsedTimeString)"
        
        let reminingTimeString = formatSecondsToString(duration - position)
        
        remainingTimeLabel.text = reminingTimeString
        //self.playerProgressView.progress
        
    }
    
    func formatSecondsToString(_ seconds: TimeInterval) -> String {
        if seconds.isNaN {
            return "00:00:00"
        }
        let sec = Int(seconds.truncatingRemainder(dividingBy: 60))
        let min = Int(seconds.truncatingRemainder(dividingBy: 3600) / 60)
        let hour = Int(seconds / 3600)
        return String(format: "%02d:%02d:%02d", hour, min, sec)
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
        
        UIView.animate(withDuration: 0.9, delay: 0 , options: .curveEaseOut) { [weak self] in
            guard let strongSelf = self else {return}
            
            strongSelf.playerView.alpha = 0.75
            strongSelf.playerControlsView.alpha = 1.0
            strongSelf.seekbarHolderView.alpha = 1.0
            
            strongSelf.view.bringSubviewToFront(strongSelf.playerView)
            strongSelf.playerView.bringSubviewToFront(strongSelf.playerControlsView)
            strongSelf.playerView.bringSubviewToFront(strongSelf.playerBackwardButtonHolderView)
            strongSelf.playerView.bringSubviewToFront(strongSelf.playerForewardButtonHolderView)
            strongSelf.playerView.bringSubviewToFront(strongSelf.playerPlayButtonHolderView)
            
            strongSelf.playerControlsView.isHidden = false
            strongSelf.seekbarHolderView.isHidden = false
            
            strongSelf.playerControlsView.isUserInteractionEnabled = true
            
            
        } completion: { finished in
            if finished {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    self.autoFadePlayerControls(duration: 0.9)
                })
            }
        }
    }
    
    public func hidePlayerControls() {
        
        self.autoFadePlayerControls(duration: 0.9)

    }
    
    @objc func backwardPlayerAction() {
        //print("VideoViewController : backward player action")
        
        self.player?.currentItem?.cancelPendingSeeks()
        
        guard let duration = self.player?.currentItem?.duration else {return}
        guard let currentTime = self.player?.currentItem?.currentTime().seconds else {return}
        
        let position = CMTimeMakeWithSeconds(currentTime - 10.0, preferredTimescale: Int32(NSEC_PER_SEC))
        
        //print("VideoViewController : postion = \(currentTime) / \(duration.timescale) = \(position)")
        
        if self.player?.currentItem?.canStepForward == true {
            let myTime = CMTime(seconds: position.seconds, preferredTimescale: duration.timescale)
            player?.seek(to: myTime, toleranceBefore: .zero, toleranceAfter: .zero)
        }
    }
    
    @objc func forwardPlayerAction() {
        //print("VideoViewController : foreward player action")
        
        self.player?.currentItem?.cancelPendingSeeks()
        
        guard let duration = self.player?.currentItem?.duration else {return}
        guard let currentTime = self.player?.currentItem?.currentTime().seconds else {return}
        
        let position = CMTimeMakeWithSeconds(currentTime + 10.0, preferredTimescale: Int32(NSEC_PER_SEC))
        
        //print("VideoViewController : postion = \(currentTime) / \(duration.timescale) = \(position)")
        
        if self.player?.currentItem?.canStepBackward == true {
            let myTime = CMTime(seconds: position.seconds, preferredTimescale: duration.timescale)
            self.player?.seek(to: myTime, toleranceBefore: .zero, toleranceAfter: .zero)
        }
    }
    
    @objc func playerPlayAction() {
        print("VideoViewController : player play action")
        
        if playButtonTap == false {
            self.playerPlayButtonImageview.image = UIImage(named: "player_play_button")
            
            if self.player?.timeControlStatus == .playing {
                self.player?.pause()
                self.progressUpdateTimer?.invalidate()
            }
        }
        else {
            self.playerPlayButtonImageview.image = UIImage(named: "player_pause_button")
            
            self.player?.play()
            self.progressUpdateTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateProgressBar), userInfo: nil, repeats: true)
            self.progressUpdateTimer?.fire()
        }
        
        playButtonTap = !playButtonTap
    }
    
    public func autoFadePlayerControls(duration:CGFloat) {
        
        print("VideoViewController : hide player controls")
        
        UIView.animate(withDuration: controlFadeSeconds,delay: 0.0,options: .transitionCrossDissolve, animations: {
            
            [weak self] in
                guard let strongSelf = self else {return}
            
            strongSelf.playerView.alpha = 1.0
                
            strongSelf.seekbarHolderView.alpha = 0.0
            strongSelf.playerControlsView.alpha = 0.0
                
            strongSelf.playerControlsView.backgroundColor = .black.withAlphaComponent(0.25)
            strongSelf.thumbnailDidTap = !strongSelf.thumbnailDidTap
            
        },completion: { isCompleted in
            
            if isCompleted {
                self.view.sendSubviewToBack(self.playerView)
                self.playerView.sendSubviewToBack(self.playerControlsView)
                self.playerView.sendSubviewToBack(self.playerBackwardButtonHolderView)
                self.playerView.sendSubviewToBack(self.playerForewardButtonHolderView)
                self.playerView.sendSubviewToBack(self.playerPlayButtonHolderView)
            }
        })
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
        
        var duration = ""
        
        if let value:String = self.videoItem?.videoDuration {
            duration = value
        }
        
        DispatchQueue.main.async {
            self.videoTitleLabel.text = title
            self.videoDescriptionLabel.text = description
            if !StringHelper.isNilOrEmpty(string: duration) {
                self.thumbnailDurationLabel.text = duration
            }
            else {
                self.thumbnailDurationLabel.isHidden = true
            }
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
                    strongSelf.playerView.isUserInteractionEnabled = false
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
        
        //self.playerView.backgroundColor = .clear
        
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
        
        self.remainingTimeLabel.textColor = UIColor.white
        self.elapsedTimeLabel.textColor = UIColor.white
        
        guard let currentItem = self.player?.currentItem else {return}

        let currentTime = CMTimeGetSeconds(currentItem.duration)

        let sec = currentTime.hashValue
        //let min = Int(currentTime / 60))
        
        self.remainingTimeLabel.text = "00 : 00"
        //self.elapsedTimeLabel.font = UIFont(name: "OpenSans-Regular", size: 4)
        
        print("VideoViewController : ela_time : \(sec) : \(currentTime)")
        
    }
    
    @IBAction func playButtonAction(_ sender : HomeButtons) {
        
        self.getVideoFromServer()
        
        DispatchQueue.main.async {
            self.player?.play()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
            self.updatePlayerControls()
            self.progressUpdateTimer?.fire()
        })
        
        self.playerView.isUserInteractionEnabled = true
        
        //self.playButton.isHidden = true
    }
    
    public func hideThumbnail() {
        DispatchQueue.main.async {
            self.view.sendSubviewToBack(self.playerThumbnailImageview)
            self.playerThumbnailImageview.isHidden = true
            self.playerThumbnailImageview.isUserInteractionEnabled = true
        }
    }
    
    public func showThumbnail() {
        DispatchQueue.main.async {
            self.view.bringSubviewToFront(self.playerThumbnailImageview)
            self.playerThumbnailImageview.isHidden = false
            self.playerThumbnailImageview.isUserInteractionEnabled = false
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
