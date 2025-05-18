//
//  PlayerHolderView.swift
//  PlayBox
//
//  Created by Thejas on 13/03/25.
//

import Foundation
import UIKit

class PlayerHolderView : UIView {
    
    @IBOutlet weak var view: UIView!
    
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    @IBOutlet weak var playerSkin: PlayerSkin!
    
    @IBOutlet weak var loader: Loader!
    
    weak var delegate : PlayerHolderDelegate!
    
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
        
        loader.skin = .PlayerView
    }
    
    private func loadViewFromNib() -> UIView {
        
        let nib = UINib(nibName: "PlayerHolderView", bundle: Bundle(for: type(of: self)))
        return nib.instantiate(withOwner: self)[0] as! UIView
        
    }
    
    func setupPlayerDelegate(delegate : PlayerHolderDelegate) {
        self.delegate = delegate
    }
    
    func configureVideo(item : VideoItem) {
        playerSkin.setupVideo(item: item)
        
        loader.showLoader()
        
        Service.getImageFrom(url: item.thumbnail) { [weak self] image in
            
            guard let self = self else {return}
            
            self.loader.hideLoader()
            
            self.setupThumbnail(image: image)
            self.showThumbnail()
            
        }
        
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        Logger.log("Called when it is loading on screen")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        Logger.log("Called after loaded on screen")
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        delegate?.closePlayer()
    }
    
    func play() {
        
        hideThumbnail()
        
        playerSkin.play()
    }
    
    func pause() {
        playerSkin.pause()
    }
    
    func setupThumbnail(image : UIImage) {
        
        DispatchQueue.main.async {
            
            self.thumbnailImageView?.image = nil
            self.thumbnailImageView?.image = AppUtilities.shared.removeBlackPadding(from: image)
            self.thumbnailImageView?.contentMode = .scaleToFill
            self.thumbnailImageView?.setNeedsLayout()
            self.thumbnailImageView?.layoutIfNeeded()
            
        }
        
    }
    
    func showThumbnail() {
        DispatchQueue.main.async {
            self.thumbnailImageView.isHidden = false
        }
    }
    
    func hideThumbnail() {
        DispatchQueue.main.async {
            self.thumbnailImageView.isHidden = true
        }
    }
    
    func cleanUp() {
        playerSkin.cleanUp()
    }
    
    func isPlaying() -> Bool {
        playerSkin.isPlaying()
    }
    
    func isDownloading() -> Bool {
        playerSkin.isDownloading()
    }
    
}
