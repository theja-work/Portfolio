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
    private let cache : NSCache<NSString, CachedResponse>
    private let cacheExpiry: TimeInterval = 60 //* 10
    
    init(api: API , cache : NSCache<NSString, CachedResponse>) {
        self.api = api
        self.cache = cache
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
    
    func getVideos(completion: @escaping (_ response:Dataloader<[VideoItem]>) -> Void) {
        
        let service = Service(api: self.url, methodType: self.httpMethod)
        let cacheKey = self.url as NSString
        
        if let cachedData = cache.object(forKey: cacheKey) , !isCacheExpired(cachedData.timestamp) {
            AppUtilities.shared.log("Returning data from cache")
            
            do {
                
                let videos = try JSONDecoder().decode([VideoItem].self, from: cachedData.data)
                
                completion(Dataloader.success(result: videos))
                
            }
            
            catch {
                print(error.localizedDescription)
                completion(Dataloader.parsingError(code: "1001", message: "Cache decoding failed"))
            }
            return
        }
        else {
            AppUtilities.shared.log("Failed to load from cache")
        }
        
        service.callWithDataLoader { dataResponse in
            
            switch dataResponse {
                
            case .success(let result) :
                
                do {
                    
                    let videos = try JSONDecoder().decode([VideoItem].self, from: result)
                    
                    let cachedResponse = CachedResponse(data: result, timestamp: Date())
                    self.cache.setObject(cachedResponse, forKey: cacheKey)
                    
                    completion(Dataloader.success(result: videos))
                    
                }
                
                catch {
                    print(error)
                    completion(Dataloader.parsingError(code: "1001", message: "parsing failed in viewmodel"))
                }
                
            case .parsingError(let code , let message) :
                
                completion(Dataloader.parsingError(code: code, message: message))
                
            case .serverError(let code, let message) :
                
                completion(Dataloader.serverError(code: code, message: message))
                
            case .dataNotFound :
                
                completion(Dataloader.dataNotFound)
                
            case .networkError :
                
                completion(Dataloader.networkError)
                
            case .unkownError :
                
                completion(Dataloader.unkownError)
                
            }
            
        }
        
    }
    
    private func isCacheExpired(_ timestamp: Date) -> Bool {
        Date().timeIntervalSince(timestamp) > cacheExpiry
    }
    
}

class CachedResponse: NSObject {
    let data: Data
    let timestamp: Date
    
    init(data: Data, timestamp: Date) {
        self.data = data
        self.timestamp = timestamp
    }
}
