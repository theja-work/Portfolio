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
    }
    
    private func loadViewFromNib() -> UIView {
        
        let nib = UINib(nibName: "PlayerHolderView", bundle: Bundle(for: type(of: self)))
        return nib.instantiate(withOwner: self)[0] as! UIView
        
    }
    
    func setupPlayerDelegate(delegate : PlayerHolderDelegate) {
        self.delegate = delegate
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
    
}
