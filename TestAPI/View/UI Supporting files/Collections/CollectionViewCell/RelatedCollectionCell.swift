//
//  RelatedCollectionCell.swift
//  TestAPI
//
//  Created by Saranyu's Macbook Pro on 12/02/24.
//

import Foundation
import CoreData
import UIKit
import RxSwift
import RxCocoa

public class RelatedCollectionCell : UICollectionViewCell {
    
    @IBOutlet weak var thumbnailImage: UIImageView!
    
    public class func getReusableIdentifier() -> String {
        return "RelatedCollectionCell"
    }
    
    public class func getNibName() -> String {
        return "RelatedCollectionCell"
    }
    
    public func setupCell(item:VideoItem,indexPath:IndexPath) {
        self.backgroundColor = ColorCodes.SkyBlue.color
        
        self.thumbnailImage.image = UIImage(named: "place_holder_4x3")
        
        if !StringHelper.isNilOrEmpty(string: item.videoID) && item.videoID != "4" {
            setImageFrom(url: item.videoThumbnailUrl)
        }
        
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10.0
    }
    
    func setImageFrom(url:String) {
        if !StringHelper.isNilOrEmpty(string: url) {
            
            ImagePickerManager.getImageFromUrl(url: url) {[weak self] imageResponse in
                
                guard let localSelf = self else {return}
                
                switch imageResponse {
                case .success(let image):
                    DispatchQueue.main.async {
                        localSelf.thumbnailImage.image = image
                        localSelf.thumbnailImage.contentMode = .scaleToFill
                    }
                    
                case .serverError(let error, let message):
                    
                    print("RelatedCollectionCell : server error with error : \(error) : message : \(message)")
                    
                default : break
                }
                
                
                
            }
            
        }
    }
    
}
