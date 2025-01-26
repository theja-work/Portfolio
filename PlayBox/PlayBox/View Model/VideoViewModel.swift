//
//  VideoViewModel.swift
//  PlayBox
//
//  Created by Thejas on 24/01/25.
//

import Foundation
import UIKit
import Combine

class VideoViewModel : VideoViewModelDependency {
    
    @Published var videoResponse: Dataloader<[VideoModel]> = .unkownError
    var api: (any VideoServiceProtocol)?
    
    private var videos : [VideoModel]?
    
    init(api: VideoServiceProtocol? = nil) {
        self.api = api
    }
    
    func getNumberOfVideos() -> Int? {
        
        return self.videos?.count
    }
    
    func getVideos() -> [VideoModel]? {
        self.videos
    }
    
    func getDataFromServer() {
        
        getCarousel()
        
    }
    
    func getVideos() {
        
        self.api?.getVideos(completion: { [weak self] response in
            
            guard let strongSelf = self else {return}
            
            switch response {
            case .success(let videoData):
                
                do {
                    
                    let videos = try JSONDecoder().decode([VideoModel].self, from: videoData)
                    strongSelf.videos = videos
                    
                    strongSelf.videoResponse = Dataloader.success(result: videos)
                }
                
                catch {
                    print(error)
                    strongSelf.videoResponse = Dataloader.parsingError(code: "1001", message: "parsing failed in viewmodel")
                }
                
            case .serverError(let code, let message):
                strongSelf.videoResponse = Dataloader.serverError(code: code, message: message)
            case .parsingError(let code, let message):
                strongSelf.videoResponse = Dataloader.parsingError(code: code, message: message)
            case .dataNotFound:
                strongSelf.videoResponse = Dataloader.dataNotFound
            case .networkError:
                strongSelf.videoResponse = Dataloader.networkError
            case .unkownError:
                strongSelf.videoResponse = Dataloader.unkownError
            }
            
        })
        
    }
    
    func getCarousel() {
        
        self.api?.getCarousel(completion: { [weak self] response in
            
            guard let strongSelf = self else {return}
            
            switch response {
            case .success(let videoData):
                
                do {
                    
                    let videos = try JSONDecoder().decode([VideoModel].self, from: videoData)
                    strongSelf.videoResponse = Dataloader.success(result: videos)
                }
                
                catch {
                    print(error)
                    strongSelf.videoResponse = Dataloader.parsingError(code: "1001", message: "parsing failed in viewmodel")
                }
                
            case .serverError(let code, let message):
                strongSelf.videoResponse = Dataloader.serverError(code: code, message: message)
            case .parsingError(let code, let message):
                strongSelf.videoResponse = Dataloader.parsingError(code: code, message: message)
            case .dataNotFound:
                strongSelf.videoResponse = Dataloader.dataNotFound
            case .networkError:
                strongSelf.videoResponse = Dataloader.networkError
            case .unkownError:
                strongSelf.videoResponse = Dataloader.unkownError
            }
            
        })
        
    }
}

