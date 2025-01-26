//
//  HomeCatalogTableViewCell.swift
//  PlayBox
//
//  Created by Thejas on 25/01/25.
//

import Foundation
import UIKit


class HomeCatalogTableViewCell : UITableViewCell {
    
    class func getCellIdentifier() -> String {
        "HomeCatalogTableViewCell"
    }
    
    class func getNibName() -> String {
        "HomeCatalogTableViewCell"
    }
    
    @IBOutlet weak var titleButton: UIButton!
    
    @IBOutlet weak var thumbnail: UIImageView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        print("HomeCatalogTableViewCell : awake from nib called")
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.thumbnail.image = nil
        self.titleButton.setTitle("", for: .normal)
    }
    
    func setupCell(video : VideoModel) {
        
        DispatchQueue.main.async {
            
            guard !video.thumbnail.isEmpty else {return}
            
            self.thumbnail.loadImage(from: URL(string: video.thumbnail)!)
            self.titleButton.setTitle(video.title, for: .normal)
            
            self.thumbnail.setNeedsLayout()
            self.thumbnail.layoutIfNeeded()
            
            self.titleButton.setNeedsLayout()
            self.titleButton.layoutIfNeeded()
            
            self.setNeedsLayout()
            self.layoutIfNeeded()
            
        }
        
    }
    
    @IBAction func titleAction(_ sender: UIButton) {
        print("Redirect to details page")
    }
    
}
