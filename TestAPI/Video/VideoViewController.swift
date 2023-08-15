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
    
    @IBOutlet weak var playerView : UIView!
    
    @IBOutlet weak var playButton : HomeButtons!
    
    @IBOutlet weak var backButton : HomeButtons!
    
    var player : AVPlayer? = nil
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonSetup()
        playerSetup()
        getVideoFromServer()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    public func playerSetup() {
        
    }
    
    public func buttonSetup() {
        self.playButton.setupStyle(type: .Video)
        self.playButton.setTitle("Play", for: .normal)
        
        self.backButton.setupStyle(type: .Video)
        self.backButton.setTitle("Back", for: .normal)
    }
    
    public func getVideoFromServer() {
        
        let videoURL = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4"
        
        let url = URL(string: videoURL)!
        
        let playerItem = AVPlayerItem(url: url)
        
        self.player = AVPlayer(playerItem: playerItem)
        
        let playerLayer = AVPlayerLayer(player: self.player)
        
        playerLayer.frame = self.playerView.bounds
        playerLayer.backgroundColor = UIColor.clear.cgColor
        
        self.playerView.layer.addSublayer(playerLayer)
        
        
        
    }
    
    @IBAction func playButtonAction(_ sender : HomeButtons) {
        
        self.player?.play()
        
        //self.playButton.isHidden = true
    }
    
    @IBAction func backButtonAction(_ sender : HomeButtons) {
        
        self.player?.pause()
        
        self.player = nil
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
}
