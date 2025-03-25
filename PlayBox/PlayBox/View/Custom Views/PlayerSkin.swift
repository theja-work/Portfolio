//
//  PlayerSkin.swift
//  PlayBox
//
//  Created by Thejas on 13/03/25.
//

import Foundation
import UIKit

class PlayerSkin : UIView {
    
    @IBOutlet weak var view : UIView!
    
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var settingsButton: UIButton!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var previousButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var elapsedTime: UILabel!
    
    @IBOutlet weak var remainingTime: UILabel!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    
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
    
    func hideControls() {
        
    }
    
    func showControls() {
        
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        
    }
    
    @IBAction func settingsAction(_ sender: UIButton) {
        
    }
    
    @IBAction func playPauseAction(_ sender: UIButton) {
        
    }
    
    @IBAction func previousAction(_ sender: UIButton) {
        
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        
    }
    
}
