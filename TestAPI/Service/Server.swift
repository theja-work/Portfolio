//
//  Server.swift
//  TestAPI
//
//  Created by Thejas K on 21/08/23.
//

import Foundation
import UIKit
import CoreData

public class Server {
    
    fileprivate var httpMethod : HTTPMethod
    fileprivate var jsonParameter : [String:Any]?
    fileprivate var serviceUrl : String
    fileprivate var hasArrayInResponse : Bool
    
    public init(httpMethod : HTTPMethod , url : String , jsonParams : [String:Any]? = nil , hasArrayInResponse:Bool = false) {
        self.httpMethod             = httpMethod
        self.serviceUrl             = url
        self.jsonParameter          = jsonParams
        self.hasArrayInResponse     = hasArrayInResponse
    }
    
    public func callWithDataLoader(responseHandler: ((_ response : DataLoader<[String:Any]>) -> Void)? = nil) {
        
        guard let url = URL(string: self.serviceUrl) else {
            
            return
        }

        var requestHTTP = URLRequest(url: url)
       // requestHTTP.timeoutInterval = 60.0
        requestHTTP.httpMethod = self.httpMethod.rawValue
        requestHTTP.cachePolicy = .reloadRevalidatingCacheData
        if jsonParameter != nil
        {
            requestHTTP.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let jsonData = try? JSONSerialization.data(withJSONObject: jsonParameter as Any)
            requestHTTP.httpBody = jsonData

            let string  = NSString(data: jsonData!, encoding: String.Encoding.utf8.rawValue)
            print("\(String(describing: string))")
        }
        
        // initate loader
        
        DispatchQueue.global().async {
            
            let task = URLSession.shared.dataTask(with: requestHTTP) { responseData, requestResponse , responseError in
                
                if responseError != nil , responseData == nil {
                    if let response = requestResponse as? HTTPURLResponse {
                        if response.statusCode == 404 {
                            
                            responseHandler?(DataLoader.dataNotFound)
                            return
                        }
                        
                        if response.statusCode == 500 {
                            
                            responseHandler?(DataLoader.serverError(error: "500", message: "Internal Server Error"))
                            return
                        }
                        
                        if response.statusCode >= 400 {
                            
                            responseHandler?(DataLoader.serverError(error: "400", message: "Bad request"))
                            return
                        }
                    }
                }
                
                if responseData != nil , responseError == nil , let data = responseData ,let response = requestResponse as? HTTPURLResponse , response.statusCode == 200 {
                    
                    if self.hasArrayInResponse {
                        let jsonDict = self.convertDataToDictionaryArray(data)
                        if let first = jsonDict.first {
                            responseHandler?(DataLoader.success(response: first))
                        }
                    }
                    else {
                        let jsonDict = self.convertDataToDictionary(data)
                    }
                }
            }
            
            task.resume()
        }
        
    }
    
}

public enum DataLoader<T> {
    case success(response:T)
    case serverError(error:String,message:String)
    case dataNotFound
    case networkError
}

public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

extension Server {
    
    func convertDataToDictionaryArray(_ data: Data) -> [[String: Any]] {
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                return jsonArray
            }
        } catch {
            print("Error parsing JSON: \(error)")
        }
        
        return []
    }
    
    func convertDataToDictionary(_ data: Data) -> [String: Any] {
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                return jsonArray
            }
        } catch {
            print("Error parsing JSON: \(error)")
        }
        
        return [:]
    }

}
