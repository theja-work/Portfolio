//
//  VideoService.swift
//  TestAPI
//
//  Created by Thejas K on 21/08/23.
//

import Foundation
import UIKit
import CoreData

public class VideoService {
    
    public class func getVideoItem(responseHandler : @escaping ((_ response : DataLoader<VideoItem>) -> Void)) {
        
        let service = VideoAPI(api: .GetVideoItem)
        
        service.apiRequest { response in
            
            switch response {
            case .success(let jsonResp) :
                
                if let video = VideoItem.Parse(jsonObject: jsonResp) {
                    responseHandler(DataLoader.success(response: video))
                }
                
            case .serverError(let error, let message) :
                
                responseHandler(DataLoader.serverError(error: error, message: message))
                
            case .dataNotFound :
                
                responseHandler(DataLoader.dataNotFound)
                
            case .networkError :
                
                responseHandler(DataLoader.networkError)
                
            //default : responseHandler(DataLoader.dataNotFound)
                
            }
            
        }
        
    }
    
    public class func getVideoItemFromLink(link:String , responseHandelr : @escaping ((_ response : DataLoader<VideoItem>) -> Void)) {
        
        let service = VideoAPI(api: .GetVideoItemFromLink(link: link))
        
        service.apiRequest(responseHandler: { response in
            switch response {
            case .success(let jsonResp) :
                if let video = VideoItem.Parse(jsonObject: jsonResp) {
                    responseHandelr(DataLoader.success(response: video))
                }
                
            case .serverError(let error, let code) :
                responseHandelr(DataLoader.serverError(error: error, message: code))
                
            default: break
            }
        } , hasArrayInresponse: false)
        
    }
    
    public class func getVideoList(responseHandler:@escaping ((_ response:DataLoader<[VideoItem]>) -> Void)) {
        
        let service = VideoAPI(api: .GetVideos)
        
        
        service.apiRequest { response in
            switch response {
            case .success(let jsonResponse):
                
                var videos = [VideoItem]()
                
                for json in jsonResponse {
                    if let videoItem = VideoItem.ParseV2(jsonObject: json) {
                        videos.append(videoItem)
                    }
                }
                
                if videos.count != 0 {
                    print("VideoService : item count : \(videos.count)")
                    responseHandler(DataLoader.success(response: videos))
                }
                else {
                    responseHandler(DataLoader.dataNotFound)
                }
                
            case .dataNotFound : responseHandler(DataLoader.dataNotFound)
                
            case .networkError : responseHandler(DataLoader.networkError)
                
            case .serverError(let error, let message):
                responseHandler(DataLoader.serverError(error: error, message: message))
            }
        }
        
        
    }
    
}

public protocol VideoServiceProtocol : AnyObject {
    func getVideoItem(response : @escaping ((DataLoader<VideoItem>) -> Void))
    func getViedoItemFromLink(link:String , response : @escaping ((DataLoader<VideoItem>) -> Void))
    func getVideos(response:@escaping ((DataLoader<[VideoItem]>) -> Void))
}
