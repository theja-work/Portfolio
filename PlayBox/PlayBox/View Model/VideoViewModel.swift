//
//  VideoViewModel.swift
//  PlayBox
//
//  Created by Thejas on 24/01/25.
//

import Foundation
import UIKit

class VideoViewModel : VideoViewModelDependency {
    
    var carouselItems: [VideoItem]? {
        
        didSet {
            videoUpdatesDelegate?.reloadList()
        }
        
    }
    
    var catalogItems: [VideoItem]? {
        
        didSet {
            videoUpdatesDelegate?.reloadList()
        }
        
    }
    
    var isLoading : Bool = false {
        
        didSet {
            AppUtilities.shared.log("isLoading : \(isLoading)")
            videoUpdatesDelegate?.updateLoader(isLoading: isLoading)
        }
        
    }
    
    var api: (any VideoServiceProtocol)?
    weak var videoUpdatesDelegate : VideoUpdatesProtocol?
    
    var group = DispatchGroup()
    
    init(api: VideoServiceProtocol? = nil , videoUpdatesDelegate : VideoUpdatesProtocol) {
        self.api = api
        self.videoUpdatesDelegate = videoUpdatesDelegate
    }
    
    func getDataFromServer() {
        
        getCarousel()
    }
    
    func getCatalogVideos() {
        
        group.enter()
        self.isLoading = true
        self.api?.getVideos(completion: { [weak self] response in
            
            guard let strongSelf = self else {
                self?.group.leave()
                return
            }
            
            strongSelf.isLoading = false
            
            switch response {
            case .success(let videoData):
                DispatchQueue.main.async {
                    strongSelf.catalogItems = videoData
                    strongSelf.videoUpdatesDelegate?.updateUI(listType: .Catalog, response: response)
                }
            default: break
            }
            
            strongSelf.group.leave()
        })
    }

    
    func getCarousel() {
        
        group.enter()
        self.isLoading = true
        self.api?.getCarousel(completion: { [weak self] response in
            
            guard let strongSelf = self else {
                self?.group.leave()
                return
            }
            
            strongSelf.isLoading = false
            
            switch response {
            case .success(let videoData):
                
                DispatchQueue.main.async {
                    
                    strongSelf.carouselItems = videoData
                    strongSelf.videoUpdatesDelegate?.updateUI(listType: .Carousel, response: response)
                    strongSelf.getCatalogVideos()
                }
                
                
                
            default : break
            }
            
            strongSelf.group.leave()
        })
        
    }
}

protocol VideoUpdatesProtocol : AnyObject {
    
    func updateUI(listType : VideoListType , response : Dataloader<[VideoItem]>)
    func reloadList()
    func updateLoader(isLoading : Bool)
    
}

enum VideoListType : String {
    case Catalog = "catalog"
    case Carousel = "carousel"
}
