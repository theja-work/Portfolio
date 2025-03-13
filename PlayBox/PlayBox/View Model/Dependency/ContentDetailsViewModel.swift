//
//  ContentDetailsViewModel.swift
//  PlayBox
//
//  Created by Thejas on 09/03/25.
//

import Foundation
import UIKit

class ContentDetailsViewModel : ContentDetailsViewModelDependency {
    
    var dataDelegate : ContentDetailsViewUpdateDelegate?
    
    private var image : UIImage? {
        
        didSet {
            dataDelegate?.updateImage(image: image)
        }
        
    }
    
    private var video : VideoItem?
    
    init(dataDelegate: ContentDetailsViewUpdateDelegate? = nil, video: VideoItem? = nil) {
        self.dataDelegate = dataDelegate
        self.video = video
    }
    
    func loadImage() {
        
        guard let imageUrl = video?.thumbnail else {return}
        
        Service.getImageFrom(url: imageUrl) { image in
            self.image = image
        }
        
    }
    
}
