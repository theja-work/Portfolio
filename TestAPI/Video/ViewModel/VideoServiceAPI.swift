//
//  VideoServiceAPI.swift
//  TestAPI
//
//  Created by Thejas K on 23/08/23.
//

import Foundation
import CoreData
import UIKit

public class VideoServiceAPI : VideoServiceProtocol {
    
    public init(){}
    
    public func getVideoItem(response: @escaping ((DataLoader<VideoItem>) -> Void)) {
        VideoService.getVideoItem(responseHandler: response)
    }
    
}
