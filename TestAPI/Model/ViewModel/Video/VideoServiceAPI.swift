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
    
    public func getViedoItemFromLink(link: String, response: @escaping ((DataLoader<VideoItem>) -> Void)) {
        VideoService.getVideoItemFromLink(link: link, responseHandelr: response)
    }
    
    public func getVideos(response: @escaping ((DataLoader<[VideoItem]>) -> Void)) {
        VideoService.getVideoList(responseHandler: response)
    }
    
    public func getVideosWithId(videoId: String, response: @escaping ((DataLoader<[VideoItem]>) -> Void)) {
        VideoService.getVideosWithId(id: videoId, responseHandler: response)
    }
    
}
