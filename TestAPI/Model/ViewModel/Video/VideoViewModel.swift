//
//  VideoViewModel.swift
//  TestAPI
//
//  Created by Thejas K on 23/08/23.
//

import Foundation
import UIKit
import CoreData

public class VideoViewModel {
    
    fileprivate var api : VideoServiceProtocol?
    var videos:[VideoItem]?
    
    public init(api: VideoServiceProtocol) {
        self.api = api
    }
    
    public func getDataFromServer(responseHandler : @escaping (_ response:DataLoader<VideoItem>) -> Void) {
        
        self.api?.getVideoItem(response: responseHandler)
        
    }
    
    public func getDataFromServerWith(videoLink : String , responseHandler : @escaping (_ response:DataLoader<VideoItem>) -> Void) {
        self.api?.getViedoItemFromLink(link: videoLink, response: responseHandler)
    }
    
    public func getVideosFromServer(responseHandler : @escaping (_ response:DataLoader<[VideoItem]>) -> Void) {
        self.api?.getVideos(response: responseHandler)
        
    }
    
    public func getVideos() {
        
        getVideosFromServer { [weak self] videoListResponse in
            
            guard let strongSelf = self else {return}
            
            switch videoListResponse {
            case .success(let videos) :
                
                strongSelf.videos = videos
                print("videos : \(videos.count)")
                
            case .serverError(let error, let message):
                print("VideoViewModel : server error with error : \(error) : \(message)")
                
            case .dataNotFound :
                print("VideoViewModel : data not found")
                
            case .networkError :
                print("VideoViewModel : connection error")
                
            }
            
        }
        
    }
    
    public func getVideosCount() -> Int? {
        
        if let count = videos?.count {return count}
        
        return nil
        
    }
    
}
