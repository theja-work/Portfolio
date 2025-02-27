//
//  Server.swift
//  PlayBox
//
//  Created by Thejas on 20/01/25.
//

import Foundation
import UIKit

class Service {
    
    private var api: String
    private var jsonParams: [String: Any]?
    private var methodType: HTTPMethods
    

    private var url: String {
        endpoint + api
    }
    
    private var endpoint: String {
        get {
            return Bundle.main.infoDictionary?["Endpoint"] as? String ?? ""
        }
    }
    
    init(api: String, jsonParams: [String: Any]? = nil, methodType: HTTPMethods) {
        self.api = api
        self.jsonParams = jsonParams
        self.methodType = methodType
    }
    
    // MARK: - API Request methods
    func callWithDataLoader(responseHandler: ((Dataloader<Data>) -> Void)?) {
        
        guard !url.isEmpty, let url = URL(string: url) else { return }
        
        print("Server.service URL: \(self.url)")

        var request = URLRequest(url: url)
        request.httpMethod = methodType.rawValue
        
        if let jsonParams = jsonParams, !jsonParams.isEmpty {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONSerialization.data(withJSONObject: jsonParams)
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            defer {
                // Reset request state after network call
                DispatchQueue.main.async {
                    self.jsonParams = nil
                    self.api = ""
                }
            }
            
            if let error = error {
                
                responseHandler?(Dataloader.serverError(code: "\(error._code)", message: error.localizedDescription))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                
                responseHandler?(Dataloader.dataNotFound)
                return
            }
            
            switch response.statusCode {
                
            case 200..<299 :
                
                if let data = data {
                    responseHandler?(Dataloader.success(result: data))
                }
                else {
                    
                }
                
            case 300..<399 :
                
                responseHandler?(Dataloader.dataNotFound)
                
                
            case 400..<499 :
                
                responseHandler?(Dataloader.dataNotFound)
                
            case 500..<599 :
                
                responseHandler?(Dataloader.serverError(code: "500", message: "Internal server error"))
                
            default :
                
                responseHandler?(Dataloader.unkownError)
                
            }
        }

        task.resume()
    }
    
    class func getImageFrom(url : String , completion : @escaping (_ image : UIImage) -> Void) {
        
        guard !url.isEmpty else {return}
        
        guard let url = URL(string: url) else {return}
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data , response , error in
            
            if let data = data , error == nil , let image = UIImage(data: data) {
                
                completion(image)
                
            }
            
        }
        
        task.resume()
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
