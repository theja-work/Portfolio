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
    
    private var isLoading : Bool = false {
        
        didSet {
            dataDelegate?.updateLoader(isLoading: isLoading)
        }
        
    }
    
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
        
        isLoading = true
        
        Service.getImageFrom(url: imageUrl) { [weak self] image in
            
            guard let localSelf = self else {return}
                
            DispatchQueue.main.asyncAfter(deadline: .now() + 0, execute: {
                localSelf.isLoading = false
            })
            
            localSelf.image = image
        }
        
    }
    
}
