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
    
    @IBOutlet weak var loader: Loader!
    
    @IBOutlet weak var detailsHolderView: DetailsHolderView!
    
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
        setupDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientation = .landscape
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        playerView.cleanUp()
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
        
        guard let item = self.video else {return}
        
        playerView.configureVideo(item: item)
    }
    
    func setupDetails() {
        
        detailsHolderView?.detailHolderDelegate = self
        
        guard let item = self.video else {return}
        
        detailsHolderView?.setupBuilder(builder: DetailsHolderComponentBuilder())
        
        viewModel?.getRelatedItems()
        
        detailsHolderView?.setupItem(item: item)
        
        detailsHolderView?.setNeedsLayout()
        detailsHolderView?.layoutIfNeeded()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if UIDevice.current.orientation.isLandscape {
            landScapeTransition()
        }
        else {
            portraitTransition()
        }
    }
    
    private func landScapeTransition() {
        
        let height = self.view.bounds.width
        let width = self.view.bounds.height
        
        playerLandscapeTransition()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.playerView.translatesAutoresizingMaskIntoConstraints = true
            self.playerView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        }
        
    }
    
    private func portraitTransition() {
        
        playerPortraitTransition()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
            self.playerView.translatesAutoresizingMaskIntoConstraints = false
            self.playerView.transform = .identity
        })
        
    }
    
    private func playerLandscapeTransition() {
        if self.playerView.layer.animation(forKey: playerRotationAnimationKey) == nil {
            let animation = CABasicAnimation(keyPath: "transform.rotation.z")
            animation.fromValue = 0
            
            animation.toValue = UIDevice.current.orientation == .landscapeRight ? -CGFloat.pi / 2 : CGFloat.pi / 2
            animation.duration = 0.05
            self.playerView.layer.add(animation, forKey: playerRotationAnimationKey)
        }
    }
    
    private func playerPortraitTransition() {
        let isLandscapeRight = UIDevice.current.orientation == .landscapeRight
        
        UIView.animate(withDuration: 0.05, animations: {
            self.playerView.transform = isLandscapeRight ? CGAffineTransform(rotationAngle: CGFloat.pi) : CGAffineTransform(rotationAngle: -CGFloat.pi)
        }) { _ in
            // Reset transform after animation to ensure proper positioning
            self.playerView.transform = .identity
        }
    }

}

extension ContentDetailsViewController : ContentDetailsViewUpdateDelegate {
    
    func updateImage(image: UIImage?) {
        
        guard let image = image else {
            Logger.log("Setup placeholder image")
            return
        }
        
        playerView.setupThumbnail(image: image)
        
    }
    
    func updateLoader(isLoading: Bool) {
        DispatchQueue.main.async {
            isLoading ? self.playerView?.loader.showLoader() : self.playerView?.loader.hideLoader()
        }
    }
    
    func updateRelated(items: [VideoItem]) {
        detailsHolderView?.setupRelatedItems(items: items)
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

extension ContentDetailsViewController : DetailsHolderDelegate {
    
    func didSelect(item: VideoItem) {
        Logger.log(item.title)
        
        playerView.configureVideo(item: item)
    }
    
    func scrollType() -> UICollectionView.ScrollDirection {
        .horizontal
    }
    
    func cellSize() -> CGSize {
        CGSize(width: 120, height: 180)
    }
    
    func play() {
        playerView.play()
    }
    
    func pause() {
        playerView.pause()
    }
    
    func startDownload() {
        
    }
    
    func pauseDownload() {
        
    }
    
    func deleteDownload() {
        
    }
    
    func isPlaying() -> Bool {
        playerView.isPlaying()
    }
    
    func isDownloading() -> Bool {
        playerView.isDownloading()
    }
    
}
