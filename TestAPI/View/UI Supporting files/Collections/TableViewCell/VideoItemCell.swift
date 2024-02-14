//
//  VideoItemCell.swift
//  TestAPI
//
//  Created by Saranyu's Macbook Pro on 11/02/24.
//

import Foundation
import UIKit
import CoreData

public class VideoItemCell : UITableViewCell {
    
    @IBOutlet weak var videoThumbnailImage : UIImageView!
    
    @IBOutlet weak var titleLabel : UILabel!
    
    @IBOutlet weak var descriptionLabel : UILabel!
    
    public class func cellIdentifier() -> String {
        return "VideoItemCell"
    }
    
    public class func nibName() -> String {
        return "VideoItemCell"
    }
    
    public func setupCell(item:VideoItem) {
        
        self.selectionStyle = .none
        
        setupImage(url: item.videoThumbnailUrl)
        
        titleLabel.text = item.videoTitle
        
        descriptionLabel.text = item.videoDescription
        
        self.backgroundColor = ColorCodes.SkyBlue.color
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 8.0
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
    }
    
    func setupImage(url:String) {
        
        self.videoThumbnailImage.image = UIImage(named: "place_holder_4x3")
        
        guard !StringHelper.isNilOrEmpty(string: url) else {return}
        
        ImagePickerManager.getImageFromUrl(url: url) { [weak self] imageLoader in
            
            guard let strongSelf = self else {return}
            
            switch imageLoader {
            case .success(let image):
                
                DispatchQueue.main.async {
                    strongSelf.videoThumbnailImage.image = image
                    strongSelf.videoThumbnailImage.contentMode = .scaleToFill
                }
                
            case .serverError(let error, let message):
                print("server error with error : \(error) : \(message)")
                
            default : break
                
            }
            
        }
        
    }
    
}
