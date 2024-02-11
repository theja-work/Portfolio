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
        
        ImagePickerManager.getImageFromUrl(url: item.videoThumbnailUrl) { [weak self] imageLoader in
            
            guard let strongSelf = self else {return}
            
            switch imageLoader {
            case .success(let image):
                strongSelf.videoThumbnailImage.image = image
                
            case .serverError(let error, let message):
                print("server error with error : \(error) : \(message)")
                
            default : break
                
            }
            
        }
        
        titleLabel.text = item.videoTitle
        
        descriptionLabel.text = item.videoDescription
        
    }
    
}
