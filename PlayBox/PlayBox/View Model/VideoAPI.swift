//
//  VideoAPI.swift
//  PlayBox
//
//  Created by Thejas on 22/01/25.
//

import Foundation

class VideoAPI {
    
    enum API {
        case Carousel
        case VideoList
    }
    
    private var api : API
    
    init(api: API) {
        self.api = api
    }
    
    private var url : String {
        switch self.api {
            
        case .Carousel : return "gist.githubusercontent.com/poudyalanil/ca84582cbeb4fc123a13290a586da925/raw/14a27bd0bcd0cd323b35ad79cf3b493dddf6216b/videos.json"
            
        case .VideoList : return "interview-e18de.firebaseio.com/media.json"
            
        }
    }
    
    private var httpMethod : HTTPMethods {
        
        switch self.api {
        case .Carousel:
            return .GET
        case .VideoList:
            return .GET
        }
        
    }
    
    func getVideos(completion: @escaping (_ response:Dataloader<Data>) -> Void) {
        
        let service = Service(api: self.url, methodType: self.httpMethod)
        
        service.callWithLoader(responseHandler: completion)
        
    }
    
}
