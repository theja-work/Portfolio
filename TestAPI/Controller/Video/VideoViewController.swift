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
import RxSwift
import RxCocoa
import NVActivityIndicatorView

public class VideoViewController : BaseViewController {
    
    public class func viewController(item:VideoItem? = nil) -> VideoViewController {
        
        let storyBoard = UIStoryboard(name: "VideoViewController", bundle: nil)
        
        let viewController = storyBoard.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
        
        if item != nil {
            viewController.videoItem = item
        }
        
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
    
    @IBOutlet weak var playerSeekBar: CustomSlider!
    
    @IBOutlet weak var remainingTimeLabel: UILabel!
    
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    
    @IBOutlet weak var descriptionHeight: NSLayoutConstraint!
    
    @IBOutlet weak var fullScreenbutton: UIButton!
    
    @IBOutlet weak var expandButton: UIButton!
    
    @IBOutlet weak var relatedContainerView: UIView!
    
    @IBOutlet weak var relatedCollectionView: UICollectionView!
    
    @IBOutlet weak var relatedCollectionHeight: NSLayoutConstraint!
    
    @IBOutlet weak var relatedCollectionTitle: UILabel!
    var expandTapped : Bool = false
    
    @IBOutlet weak var fullScreenHolderButton: UIButton!
    
    @IBOutlet weak var watch_history_indicator: UIProgressView!
    
    public static let AppKilledNotifier = Notification.Name.init("App_killed_notification")
    
    fileprivate var last_position : Double = 0.0
    
    var playerLayer : AVPlayerLayer?
    
    var fullScreenTapped : Bool = false
    
    public var progressUpdateTimer : Timer?
    
    var player : AVPlayer? = nil
    var animationCounter = 0
    var playerLoader : NVActivityIndicatorView!
    var topNavBarPlayerOffset = 0.0
    var thumbnailDidTap = false
    var playButtonTap = false
    var backwardButtonTap = false
    var forwardButtonTap = false
    var controlFadeSeconds = 0.9
    
    private var playerItemBufferEmptyObserver: NSKeyValueObservation?
    private var playerItemBufferKeepUpObserver: NSKeyValueObservation?
    private var playerItemBufferFullObserver: NSKeyValueObservation?
    
    var videoItem : VideoItem?
    var viewModel : VideoViewModel?
    
    let playerRotationAnimationKey = "on_rotation_key"
    let playerScaleAnimationKey = "on_scale_key"
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = ColorCodes.SkyBlue.color
        
        guard let navHeight = self.navigationController?.navigationBar.frame.size.height else {return}
        
        topNavBarPlayerOffset = (navHeight - 3) * 2
        
        self.navigationController?.navigationBar.backItem?.backButtonTitle = ""
        
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnded), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        
        NotificationCenter.default.addObserver(self, selector: #selector(saveVideoPosition), name: VideoViewController.AppKilledNotifier, object: nil)
        
        
    }
    
    @objc func saveVideoPosition() {
        
        guard let uuid = AppUserDefaults.getCurrentUserUUID() else {return}
        
        guard var user = ProfileMangager().getProfileBy(id: uuid) else {return}
        
        guard let position = self.player?.currentItem?.currentTime().seconds else {return}
        
        guard let duration = self.player?.currentItem?.duration.seconds else {return}
        
        if duration - position < 5.0 {return}
        
        guard let videoID = self.videoItem?.videoID else {return}
        
        let newPosition = [videoID:position]
        var watchHistory = [String:Double]()
        
        do {
            if let previousData = user.watch_history_data {
                watchHistory = try JSONDecoder().decode([String:Double].self, from: previousData)
                
                if !watchHistory.isEmpty && watchHistory.count > 0 {
                    
                    watchHistory.merge(dict: newPosition)
                    
                    user.watch_history_data = try JSONEncoder().encode(watchHistory)
                }
            }
            else {
                
                if !newPosition.isEmpty && newPosition.count > 0 {
                    watchHistory = newPosition

                    user.watch_history_data = try JSONEncoder().encode(watchHistory)
                }
            }
            
        }
        catch {
            print(error)
        }
        
        if ProfileMangager().updateProfile(user: user) {
            print("VideoViewController : video position saved")
        }
        
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        saveVideoPosition()
        super.viewWillDisappear(animated)
        self.player?.replaceCurrentItem(with: nil)
        self.player?.pause()
        self.player = nil
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if self.player?.timeControlStatus == .playing {
            self.player?.pause()
        }
        
        self.videoItem = nil
        self.player = nil
    }
    
    deinit {
        self.player?.seek(to: CMTime.zero)
        self.player?.replaceCurrentItem(with: nil)
        self.player?.pause()
        self.player = nil
    }
    
    func resetThumbnail() {
        
        if playerThumbnailImageview != nil {
            playerThumbnailImageview?.image = UIImage(named: "")
        }
        
    }
    
    public func setupViewModel() {
        
        self.viewModel = VideoViewModel(api: VideoServiceAPI())
        
        guard let videoId = self.videoItem?.videoID else {return}
        
        self.viewModel?.getRelatedVideos(withId: videoId)
        
        setupRelatedVideosObserver()
        
    }
    
    func setupRelatedVideosObserver() {
        
        self.viewModel?.output.relatedVideosDriver.drive(onNext: {[weak self] relatedVideos in
            
            guard let localSelf = self else {return}
            
            localSelf.relatedCollectionView.reloadData()
            
            
        }).disposed(by: bag)
        
    }
    
    @objc func videoDidEnded() {
        
        guard let item = self.viewModel?.relatedVideos?.first else {return}
        
        resetPlayer()
        
        updatePlayerWithItem(item: item)
        
        self.playVideo()
        
    }
    
    func resetPlayer() {
        
        playerLayer?.player = nil
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
        
        if player != nil {
            self.player?.pause()
            self.player?.seek(to: CMTime.zero)
            self.player?.replaceCurrentItem(with: nil)
            self.player = AVPlayer(playerItem: nil)
        }
    }
    
    public func setupLoader() {
        self.playerLoader = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40),type: .lineScale)
        
        
        playerLoader.color = ColorCodes.turmeric.color
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
        
        //getVideo()
        
        setupMetaData()
        setupThumbnail()
        
        setupRelatedCollection()
        setupPlayerControls()
    }
    
    func setupRelatedCollection() {
        
        relatedCollectionView.register(UINib(nibName: RelatedCollectionCell.getNibName(), bundle: Bundle(for: RelatedCollectionCell.classForCoder())), forCellWithReuseIdentifier: RelatedCollectionCell.getReusableIdentifier())
        
        if let layout = relatedCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        relatedCollectionHeight.constant = 150
        
        relatedCollectionTitle.text = "Related Videos"
        
        relatedCollectionTitle.font = CustomFont.OS_Semibold.font
        
    }
    
    func getVideo() {
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
            
            self.playerSeekBar.minimumTrackTintColor = ColorCodes.turmeric.color
            self.playerSeekBar.maximumTrackTintColor = ColorCodes.BlueGray.color
            
            self.playerSeekBar.isContinuous = true
            self.playerSeekBar.addTarget(self, action: #selector(self.sliderValueChanged(_:)), for: .valueChanged)
            
            self.playerForewardButtonHolderView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self.playerBackwardButtonHolderView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self.playerPlayButtonHolderView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self.seekbarHolderView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            
        }
        
    }
    
    @objc func sliderValueChanged(_ playbackSlider: UISlider){

        let seconds : Float = Float(playbackSlider.value)
        //let targetTime:CMTime = CMTimeMake(value: Int64(seconds), timescale: 1)
        
        //self.player?.pause()
        self.showLoader()
        if let duration = self.player?.currentItem?.duration {
            
            let totalSeconds = CMTimeGetSeconds(duration)
            
            let value = Float64(playerSeekBar.value) * totalSeconds
            
            let seekTime = CMTime(value: CMTimeValue(value), timescale: 1)
            
            self.player?.currentItem?.seek(to: seekTime,completionHandler: {[weak self] (completed) in
                
                guard let localSelf = self else {return}
                
                //localSelf.player?.play()
                localSelf.hideLoader()
            })
            
        }
    }
    
    @objc func updateProgressBar() {
        
        guard let position = self.player?.currentItem?.currentTime().seconds else {return}
        guard let duration = self.player?.currentItem?.duration.seconds else {return}
        
        let elapsedTimeString = formatSecondsToString(position)
        let reminingTimeString = formatSecondsToString(duration - position)
        
        if self.player?.timeControlStatus == .playing {
            
            DispatchQueue.main.async {
                
                self.playerSeekBar.setValue(Float(position / duration), animated: true)
            }
        }
        
        elapsedTimeLabel.text = reminingTimeString
        remainingTimeLabel.text = elapsedTimeString
        
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
        
        self.player?.currentItem?.cancelPendingSeeks()
        
        guard let duration = self.player?.currentItem?.duration else {return}
        guard let currentTime = self.player?.currentItem?.currentTime().seconds else {return}
        
        let position = CMTimeMakeWithSeconds(currentTime - 10.0, preferredTimescale: Int32(NSEC_PER_SEC))
        
        
        if self.player?.currentItem?.canStepForward == true {
            let myTime = CMTime(seconds: position.seconds, preferredTimescale: duration.timescale)
            player?.seek(to: myTime, toleranceBefore: .zero, toleranceAfter: .zero)
        }
    }
    
    @objc func forwardPlayerAction() {
        
        self.player?.currentItem?.cancelPendingSeeks()
        
        guard let duration = self.player?.currentItem?.duration else {return}
        guard let currentTime = self.player?.currentItem?.currentTime().seconds else {return}
        
        let position = CMTimeMakeWithSeconds(currentTime + 10.0, preferredTimescale: Int32(NSEC_PER_SEC))
        
        
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
            
            self.playerView.isUserInteractionEnabled = true
            self.player?.play()
            self.progressUpdateTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateProgressBar), userInfo: nil, repeats: true)
            self.progressUpdateTimer?.fire()
        }
        
        playButtonTap = !playButtonTap
    }
    
    public func autoFadePlayerControls(duration:CGFloat) {
        
        print("VideoViewController : hide player controls")
        
        UIView.animate(withDuration: controlFadeSeconds,delay: 0.0,options: .transitionCrossDissolve, animations: { [weak self] in
                
            guard let strongSelf = self else {return}
            
            strongSelf.playerView.alpha = 1.0
                
            strongSelf.seekbarHolderView.alpha = 0.0
            strongSelf.playerControlsView.alpha = 0.0
                
            strongSelf.playerControlsView.backgroundColor = .black.withAlphaComponent(0.25)
            strongSelf.thumbnailDidTap = !strongSelf.thumbnailDidTap
            
        },completion: { isCompleted in
            
            if isCompleted {
                self.playerView.isUserInteractionEnabled = true
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
            self.metaDataHolderView.clipsToBounds = true
            self.metaDataHolderView.layer.masksToBounds = true
            self.metaDataHolderView.layer.cornerRadius = 10
            self.metaDataHolderView.backgroundColor = ColorCodes.ButtonBlueDark.color
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
            self.playerThumbnailImageview.image = UIImage(named: "place_holder_4x3")
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
                    strongSelf.playerThumbnailImageview.contentMode = .scaleToFill
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
        
        setupWatchHistoryProgress()
    }
    
    func setupWatchHistoryProgress() {
        
        guard let uuid = AppUserDefaults.getCurrentUserUUID() else {return}
        guard let user = ProfileMangager().getProfileBy(id: uuid) else {return}
        guard let videoID = self.videoItem?.videoID else {return}
        guard let videoURL = self.videoItem?.videoUrl else {return}
        
        let url = URL(string: videoURL)!
        
        let asset = AVURLAsset(url: url)
        
        let duration = asset.duration.seconds
        
        do {
            if let data = user.watch_history_data {
                let watch_history = try JSONDecoder().decode([String:Double].self, from: data)
                
                if !watch_history.isEmpty && watch_history.count > 0 {
                    
                    if let position = watch_history[videoID] {
                        
                        guard position > 0 && duration > 0 else {return}
                        
                        last_position = position
                        
                        watch_history_indicator.isHidden = false
                        watch_history_indicator.progressTintColor = ColorCodes.turmeric.color
                        watch_history_indicator.setProgress(Float(position / duration), animated: true)
                        
                    }
                    else {
                        watch_history_indicator.isHidden = true
                    }
                    
                }
                
            }
            else {
                watch_history_indicator.isHidden = true
            }
        }
        catch {
            print(error)
        }
    }
    
    public func labelUISetup() {
        
        DispatchQueue.main.async {
            self.videoTitleLabel.font = CustomFont.OS_Bold.font
            self.videoDescriptionLabel.font = CustomFont.OS_Semibold.font
            self.videoDescriptionLabel.numberOfLines = 4
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
        
//        playerItemBufferEmptyObserver = player?.currentItem?.observe(\AVPlayerItem.isPlaybackBufferEmpty, options: [.new]) { [weak self] (_, _) in
//            guard let self = self else { return }
//            print("player_loading_state : loading")
//            self.showLoader()
//        }
//
//        playerItemBufferKeepUpObserver = player?.currentItem?.observe(\AVPlayerItem.isPlaybackLikelyToKeepUp, options: [.new]) { [weak self] (_, _) in
//            guard let self = self else { return }
//            print("player_loading_state : not loading")
//            self.hideLoader()
//        }
//
//        playerItemBufferFullObserver = player?.currentItem?.observe(\AVPlayerItem.isPlaybackBufferFull, options: [.new]) { [weak self] (_, _) in
//            guard let self = self else { return }
//            print("player_loading_state : not loading")
//            self.hideLoader()
//        }
        
        self.player?.currentItem?.rx.playbackBufferEmpty.subscribe(onNext: {[weak self] (isLoading) in
            
            guard let localSelf = self else {return}
            
            if isLoading {
                localSelf.showLoader()
            }
            else {
                localSelf.hideLoader()
            }
            
        })
    }
    
    public override func removeObserver(_ observer: NSObject, forKeyPath keyPath: String) {
        
        playerItemBufferEmptyObserver?.invalidate()
        playerItemBufferEmptyObserver = nil
            
        playerItemBufferKeepUpObserver?.invalidate()
        playerItemBufferKeepUpObserver = nil
            
        playerItemBufferFullObserver?.invalidate()
        playerItemBufferFullObserver = nil
        
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        if fullScreenTapped { fullScreenTapped = false; return}
        
        fullScreenTransition()
    }
    
    func fullScreenTransition(fullScreenTapped:Bool = false) {
        guard topNavBarPlayerOffset != 0 else {return}
        
        if UIDevice.current.orientation.isLandscape {
            
            fullScreenTapped ? portraitPlayerUpdates() : landscapePlayerUpdates()
            
            
        } else {
            
            fullScreenTapped ? landscapePlayerUpdates() : portraitPlayerUpdates()
            
        }
        
        if animationCounter == 1 {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 5) { [weak self] in
                guard let strongSelf = self else {return}
                
                fullScreenTapped ? strongSelf.portraitPlayerBlock() : strongSelf.landscapePlayerBlock()
                
            }
            
        }
        else {
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 5) { [weak self] in
                guard let strongSelf = self else {return}
                
                fullScreenTapped ? strongSelf.landscapePlayerBlock() : strongSelf.portraitPlayerBlock()
                
            }
            
        }
    }
    
    public func landscapePlayerUpdates() {
        
        self.navigationController?.isNavigationBarHidden = true
        self.animationCounter = 1
        
        playerViewTopConstraint.constant = topNavBarPlayerOffset//82
        
        hidePlayerButtons()
    }
    
    public func portraitPlayerUpdates() {
        self.navigationController?.isNavigationBarHidden = false

        self.animationCounter = 0
        
        playerViewTopConstraint.constant = 0
        
        showPlayerButtons()
    }
    
    func landscapePlayerBlock(onFullScreenTap:Bool = false) {
        let x = 16.0/9.0
        
        playerLandscapeTransition()
        
        if !onFullScreenTap {
            hideMetaData()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.playerView.transform = CGAffineTransform(scaleX: x, y: x)
        })
    }
    
    func portraitPlayerBlock(onFullScreenTap:Bool = false) {
        playerPortraitTransition()
        
        if !onFullScreenTap {
            showMetaData()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            
            self.playerView.transform = .identity
        })
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
        
        self.fullScreenbutton.setImage(UIImage(named: "fullscreen"), for: .normal)
        self.expandButton.setImage(UIImage(named: "dropdown_down"), for: .normal)
//        self.expandButton.isHidden = true
//        self.expandButton.isUserInteractionEnabled = false
        
    }
    
    public func getVideoFromServer() {
        
        //self.playerView.backgroundColor = .clear
        
        //let videoURL = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4"
        
        guard let videoURL = self.videoItem?.videoUrl else {return}
        
        let url = URL(string: videoURL)!
        
        let playerItem = AVPlayerItem(url: url)
        
        if self.player != nil {return}
        
        self.player?.replaceCurrentItem(with: nil)
        self.player = AVPlayer(playerItem: playerItem)
        
        playerLayer = AVPlayerLayer(player: self.player)
        
        playerLayer?.frame = self.playerView.bounds
        playerLayer?.backgroundColor = UIColor.clear.cgColor
        
        
        playerLayer?.videoGravity = .resizeAspect
        self.playerView.layer.addSublayer(playerLayer!)
        
        self.remainingTimeLabel.textColor = UIColor.white
        self.elapsedTimeLabel.textColor = UIColor.white
        
        self.player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges",options: .new ,context: nil)
        
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "currentItem.loadedTimeRanges" {
            //
            
        }
        
    }
    
    @IBAction func fullScreenAction(_ sender: UIButton) {
        
        fullScreenButtonAction()
    }
    
    @IBAction func playButtonAction(_ sender : HomeButtons) {
        
        playerView.isUserInteractionEnabled = true
        playVideo()
        
        addPlayerObservers()
        
        //self.playButton.isHidden = true
    }
    
    func playVideo() {
        
        self.getVideoFromServer()
        
        self.playerView.isUserInteractionEnabled = true
        DispatchQueue.main.async {
            
            if self.last_position > 0 {
                
                let seekTime = CMTime(value: CMTimeValue(self.last_position), timescale: 1)
                
                self.player?.currentItem?.seek(to: seekTime,completionHandler: nil)
                self.watch_history_indicator.isHidden = true
            }
            
            self.player?.play()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
            self.updatePlayerControls()
            self.progressUpdateTimer?.fire()
        })
        
        addPlayerObservers()
    }
    
    @IBAction func expandButtonAction(_ sender: UIButton) {
        
        if expandTapped {
            videoDescriptionLabel.numberOfLines = 4
            descriptionHeight.constant = 50
            self.expandButton.setImage(UIImage(named: "dropdown_down"), for: .normal)
            self.metaDataScrollView.setContentOffset(CGPoint.zero, animated: true)
            //self.scrollableContentHeight.constant = 650
        }
        else {
            videoDescriptionLabel.numberOfLines = 0
            descriptionHeight.constant = 150
            self.expandButton.setImage(UIImage(named: "dropdown_up"), for: .normal)
            //self.scrollableContentHeight.constant = 1000
        }
        
        expandTapped = !expandTapped
        
    }
    
    @objc func fullScreenButtonAction() {
        
        fullScreenTapped = true
        
        let orientation = self.view.window?.windowScene?.interfaceOrientation
        
        if orientation == .landscapeLeft || orientation == .landscapeRight {
            if #available(iOS 16.0, *) {
                UIView.performWithoutAnimation {
                    self.setNeedsUpdateOfSupportedInterfaceOrientations()
                }
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait)) { error in
                        print(error)

                    }
                    
                    self.portraitPlayerUpdates()
                    self.portraitPlayerBlock()
                })
            } else {
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                UIViewController.attemptRotationToDeviceOrientation()
                portraitPlayerUpdates()
                portraitPlayerBlock()
            }
            
            
        }
        else {
            if #available(iOS 16.0, *) {
                UIView.performWithoutAnimation {
                    self.setNeedsUpdateOfSupportedInterfaceOrientations()
                }
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .landscapeRight)) { error in
                        print(error)
                    }
                    
                    self.landscapePlayerUpdates()
                    self.landscapePlayerBlock()
                })
            }else {
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
                UIViewController.attemptRotationToDeviceOrientation()
                landscapePlayerUpdates()
                landscapePlayerBlock()
            }
            
            
        }
        
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
    
    @objc func hidePlayerButtons() {
        self.playButton.isHidden = true
        self.backButton.isHidden = true
        self.playButton.isUserInteractionEnabled = false
        self.backButton.isUserInteractionEnabled = false
    }
    
    @objc func showPlayerButtons() {
        self.playButton.isHidden = false
        self.backButton.isHidden = false
        self.playButton.isUserInteractionEnabled = true
        self.backButton.isUserInteractionEnabled = true
    }
    
    func updatePlayerWithItem(item:VideoItem) {
        
        self.player = nil
        self.player?.replaceCurrentItem(with: nil)
        //self.playerView.gestureRecognizers?.forEach(playerView.removeGestureRecognizer)
        
        self.videoItem = item
        self.resetThumbnail()
        self.setupViewModel()
        self.buttonSetup()
        self.playerSetup()
        
        thumbnailDidTap = false
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    
}

extension VideoViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.viewModel?.getRelatedVideosCount() ?? 0
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RelatedCollectionCell.getReusableIdentifier(), for: indexPath) as! RelatedCollectionCell
        
        if let item = self.viewModel?.relatedVideos?[indexPath.row] {
            cell.setupCell(item: item)
        }
        else {
            cell.setupCell(item: VideoItem())
        }
        
        return cell
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = collectionView.frame.height
        
        let width = height * 4 / 3
        
        return CGSize(width: width, height: height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        saveVideoPosition()
        resetPlayer()
        self.player?.replaceCurrentItem(with: nil)
        self.player = nil
        guard let item = self.viewModel?.relatedVideos?[indexPath.row] else {return}
        
        updatePlayerWithItem(item: item)
        
    }
    
}

extension Reactive where Base: AVPlayerItem {
    public var playbackBufferEmpty: Observable<Bool> {
        return self.observe(Bool.self, #keyPath(AVPlayerItem.isPlaybackBufferEmpty))
            .map { $0 ?? false }
    }
}
