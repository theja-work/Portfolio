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
                
            default : responseHandler(DataLoader.dataNotFound)
                
            }
            
        }
        
    }
    
}

public protocol VideoServiceProtocol : AnyObject {
    func getVideoItem(response : @escaping ((DataLoader<VideoItem>) -> Void))
}
