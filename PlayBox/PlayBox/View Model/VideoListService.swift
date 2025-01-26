//
//  VideoListService.swift
//  PlayBox
//
//  Created by Thejas on 24/01/25.
//

import Foundation

class VideoListService : VideoServiceProtocol {
    
    init(){}
    
    func getVideos(completion : @escaping (Dataloader<Data>) -> Void) {
        
        let api = VideoAPI(api: .VideoList)
        
        api.getVideos(completion: completion)
        
    }
    
    func getCarousel(completion: @escaping (Dataloader<Data>) -> Void) {
        
        let api = VideoAPI(api: .Carousel)
        
        api.getVideos(completion: completion)
        
    }
    
}
