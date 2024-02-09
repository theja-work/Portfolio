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
    
    public init(api: VideoServiceProtocol) {
        self.api = api
    }
    
    public func getDataFromServer(responseHandler : @escaping (_ response:DataLoader<VideoItem>) -> Void) {
        
        self.api?.getVideoItem(response: responseHandler)
        
    }
    
    public func getDataFromServerWith(videoLink : String , responseHandler : @escaping (_ response:DataLoader<VideoItem>) -> Void) {
        self.api?.getViedoItemFromLink(link: videoLink, response: responseHandler)
    }
    
}
