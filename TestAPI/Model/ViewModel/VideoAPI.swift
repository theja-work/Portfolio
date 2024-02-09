//
//  VideoAPI.swift
//  TestAPI
//
//  Created by Thejas K on 23/08/23.
//

import Foundation
import CoreData

public class VideoAPI {
    
    public enum API {
        case GetVideoItem
        case GetVideoItemFromLink(link:String)
    }
    
    var urlPath : String {
        switch api {
        case .GetVideoItem : return "https://gist.githubusercontent.com/poudyalanil/ca84582cbeb4fc123a13290a586da925/raw/14a27bd0bcd0cd323b35ad79cf3b493dddf6216b/videos.json"
        case .GetVideoItemFromLink(let link) :
            return link
            
        }
    }
    
    var api : API
    
    var httpMethod : HTTPMethod {
        switch api {
        case .GetVideoItem : return .get
        case .GetVideoItemFromLink : return .get
        }
    }
    
    public init(api : API) {
        self.api = api
    }
    
    public func apiRequest(responseHandler : ((_ response : DataLoader<[String:Any]>) -> Void)? = nil) {
        
        let service = Server(httpMethod: httpMethod, url: urlPath , hasArrayInResponse: true)
        
        service.callWithDataLoader(responseHandler: responseHandler)
    }
    
    public func apiRequest(responseHandler : ((_ response : DataLoader<[String:Any]>) -> Void)? = nil , hasArrayInresponse : Bool = false) {
        
        let service = Server(httpMethod: httpMethod, url: urlPath , hasArrayInResponse: hasArrayInresponse)
        
        service.callWithDataLoader(responseHandler: responseHandler)
    }
    
}
