//
//  PlayerSkin.swift
//  PlayBox
//
//  Created by Thejas on 13/03/25.
//

import Foundation
import UIKit
import AVKit

class PlayerSkin : UIView {
    
    @IBOutlet weak var view : UIView!
    
    @IBOutlet weak var metadataHolderView: UIView!
    
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var settingsButton: UIButton!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var previousButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var elapsedTime: UILabel!
    
    @IBOutlet weak var remainingTime: UILabel!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    private var player : AVPlayer?
    private var playerLayer : AVPlayerLayer?
    
    private var item : VideoItem?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup() 
    }
    
    private func setup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView? {
        
        let nib = UINib(nibName: "PlayerSkin", bundle: Bundle(for: type(of: self)))
        return nib.instantiate(withOwner: self)[0] as? UIView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playerLayer?.frame = view.bounds
    }
    
    func setupVideo(item : VideoItem) {
        
        self.item = item
        
        setupTitle()
        setupPlayer()
        
    }
    
    func setupTitle() {
        
    }
    
    func setupPlayer() {
        
        cleanUp()
        
        guard let video = item else {return}
        
        guard let url = URL(string: video.videoUrl) else {return}
        
        Logger.log(video.videoUrl)
        
        let item = AVPlayerItem(url: url)
        
        player = AVPlayer(playerItem: item)
        
        playerLayer = AVPlayerLayer(player: player)
        
        playerLayer?.frame = view.bounds
        
        playerLayer?.videoGravity = .resizeAspect
        
        view.layer.insertSublayer(playerLayer!, at: 0)
        
        playerLayer?.needsDisplayOnBoundsChange = true
        
    }
    
    func hideControls() {
        
        DispatchQueue.main.async {
            self.metadataHolderView.isHidden = true
        }
        
    }
    
    func showControls() {
        
        DispatchQueue.main.async {
            self.metadataHolderView.isHidden = true
        }
        
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        
    }
    
    @IBAction func settingsAction(_ sender: UIButton) {
        
    }
    
    @IBAction func playPauseAction(_ sender: UIButton) {
        Logger.log("PlayPause Action")
    }
    
    @IBAction func previousAction(_ sender: UIButton) {
        
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        
    }
    
    func getDuration() -> String {
        
        guard let duration = player?.currentItem?.duration,
              CMTimeGetSeconds(duration).isFinite else {
            return "00h : 00m"
        }
        
        let totalSeconds = Int(CMTimeGetSeconds(duration))
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        
        return String(format: "%02dh : %02dm", hours, minutes)
    }
    
    func play() {
        
        hideControls()
        
        player?.play()
    }
    
    func pause() {
        
        player?.pause()
        
    }
    
    func isPlaying() -> Bool {
        
        guard let player = player else {return false}
        
        return player.timeControlStatus == .playing
    }
    
    func isDownloading() -> Bool {
        false
    }
    
    func cleanUp() {
        
        pause()
        player?.replaceCurrentItem(with: nil)
        player = nil
        
    }
    
}
