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
    
    public func setupCell(item:VideoItem) {
        self.backgroundColor = ColorCodes.SkyBlue.color
        
        let thumbnail = item.videoThumbnailUrl
        
        self.thumbnailImage.image = UIImage(named: "place_holder_4x3")
        
        if !StringHelper.isNilOrEmpty(string: thumbnail) {
            
            ImagePickerManager.getImageFromUrl(url: thumbnail) {[weak self] imageResponse in
                
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
        
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10.0
    }
    
}
