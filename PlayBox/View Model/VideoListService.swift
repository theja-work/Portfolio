//
//  VideoListService.swift
//  PlayBox
//
//  Created by Thejas on 24/01/25.
//

import Foundation

class VideoListService : VideoServiceProtocol {
    
    init(){}
    
    private let sharedCache = NSCache<NSString, CachedResponse>()
    
    func getVideos(completion : @escaping (Dataloader<[VideoItem]>) -> Void) {
        
        let api = VideoAPI(api: .VideoList, cache: sharedCache)
        
        api.getVideos(completion: completion)
        
    }
    
    func getCarousel(completion: @escaping (Dataloader<[VideoItem]>) -> Void) {
        
        let api = VideoAPI(api: .Carousel, cache: sharedCache)
        
        api.getVideos(completion: completion)
        
    }
    
}
