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
    
    private let sharedCache = NSCache<NSString, CachedResponse>()
    
    private var isLoading : Bool = false {
        
        didSet {
            dataDelegate?.updateLoader(isLoading: isLoading)
        }
        
    }
    
    private var video : VideoItem?
    
    private var relatedVideos : [VideoItem] = [] {
        
        didSet {
            DispatchQueue.main.async {
                self.dataDelegate?.updateRelated(items: self.relatedVideos)
            }
        }
        
    }
    
    init(dataDelegate: ContentDetailsViewUpdateDelegate? = nil, video: VideoItem? = nil) {
        self.dataDelegate = dataDelegate
        self.video = video
    }
    
    func getRelatedItems() {
        
        let relatedApi = VideoAPI(api: .Related, cache: sharedCache)
        
        isLoading = true
        relatedApi.getVideos { [weak self] response in
            
            guard let self = self else {return}
            
            self.isLoading = false
            
            switch response {
            case .success(let videos):
                self.relatedVideos = videos
            case .serverError(let code, let message):
                Logger.log("Server error with : \(code) : \(message)")
            case .parsingError(let code, let message):
                Logger.log("Parsing error with : \(code) : \(message)")
            case .dataNotFound:
                Logger.log("dataNotFound")
            case .networkError:
                Logger.log("networkError")
            case .unkownError:
                Logger.log("unkownError")
            }
            
        }
        
    }
    
}
