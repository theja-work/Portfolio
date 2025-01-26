//
//  Server.swift
//  PlayBox
//
//  Created by Thejas on 20/01/25.
//

import Foundation
import UIKit

class Service {
    
    private var api : String
    private var jsonParams : [String:Any]?
    private var methodType : HTTPMethods = .GET
    private var cache : NSCache<NSString,NSData>
    
    private var url : String {
        endpoint + api
    }
    
    private var endpoint : String {
        
        set {
            print("Server.current endpoint reset : \(newValue)")
        }
        
        get {
            if let value : String = Bundle.main.infoDictionary?["Endpoint"] as? String {
                print("Server.current endpoint from plist : \(value)")
                
                return value
            }
            
            return ""
        }
        
    }
    
    init(api: String, jsonParams: [String : Any]? = nil, methodType: HTTPMethods) {
        self.api = api
        self.jsonParams = jsonParams
        self.methodType = methodType
        self.cache = NSCache<NSString,NSData>()
    }
    
    //MARK: - API Request methods
    
    func callWithLoader(responseHandler : (((Dataloader<Data>)) -> Void)?) {
        
        guard !url.isEmpty else {return}
        
        guard let url = URL(string: url) else {return}
        
        print("Sever.service url : \(self.url)")
        
        var request = URLRequest(url: url)
        request.httpMethod = methodType.rawValue
        
//        if let value = cache.value(forKey: (self.api as NSString) as String) as? Data {
//            responseHandler?(Dataloader.success(result: value))
//            print("Returning data from cache")
//            return
//        }
        
        if jsonParams != nil && jsonParams?.count != 0 {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let data = try? JSONSerialization.data(withJSONObject: jsonParams!)
            request.httpBody = data
            
            if let data = data {
                let string  = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                print("\(String(describing: string))")
            }
            
        }
        
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "global.queue", qos: .background , attributes: .concurrent)
        
        queue.async {
            
            group.enter()
            
            let task = URLSession.shared.dataTask(with: request) { data , response , error in
                
                group.leave()
                
                if let error = error as? NSError , let response = response as? HTTPURLResponse {
                    
                    if response.statusCode == 500 {
                        responseHandler?(Dataloader.serverError(code: "500", message: "Internal server error"))
                    }
                    
                    if response.statusCode >= 400 {
                        responseHandler?(Dataloader.dataNotFound)
                    }
                    
                }
                
                if let data = data , let completion = responseHandler , let response = response as? HTTPURLResponse {
                    
                    if response.statusCode >= 200 && response.statusCode <= 299  {
                        
                        //self.cache.setValue(data, forKey: (self.api as NSString) as String)
                        
                        completion(Dataloader.success(result: data))
                        
                    }
                    
                }
                
            }
            
            task.resume()
            
        }
        
        group.notify(queue: queue) {
            print("Server is free ")
            self.jsonParams = nil
            self.api = ""
        }
        
    }
    
    
    
}

enum HTTPMethods : String {
    
    case PUT = "PUT"
    case GET = "GET"
    case DELETE = "DELETE"
    case UPDATE = "UPDATE"
    
}

enum Dataloader<T> {
    case success(result:T)
    case serverError(code:String,message:String)
    case parsingError(code:String,message:String)
    case dataNotFound
    case networkError
    case unkownError
}
