//
//  VideoModel.swift
//  TestAPI
//
//  Created by Thejas K on 21/08/23.
//

import Foundation
import UIKit
import CoreData

public class VideoItem : Codable {
    
    public var videoUrl : String = ""
    public var videoThumbnailUrl : String = ""
    public var videoTitle : String = ""
    public var videoDescription : String = ""
    public var videoDuration : String = ""
    public var videoID:String = ""
    
    public init(videoID:String ,videoUrl: String, videoThumbnailUrl: String, videoTitle: String, videoDescription: String, videoDuration: String) {
        
        self.videoID = videoID
        self.videoUrl = videoUrl
        self.videoThumbnailUrl = videoThumbnailUrl
        self.videoTitle = videoTitle
        self.videoDescription = videoDescription
        self.videoDuration = videoDuration
    }
    
    init(){}
    
    public class func Parse(jsonObject : [String:Any]) -> VideoItem? {
        
        let video = VideoItem()
        
        if let value : String = jsonObject.valueFor(key: "title") {
            video.videoTitle = value
        }
        
        if let value : String = jsonObject.valueFor(key: "thumbnailUrl") {
            video.videoThumbnailUrl = value
        }
        
        if let value : String = jsonObject.valueFor(key: "videoUrl") {
            video.videoUrl = value
        }
        
        if let value : String = jsonObject.valueFor(key: "description") {
            video.videoDescription = value
        }
        
        if let value : String = jsonObject.valueFor(key: "duration") {
            video.videoDuration = value
        }
        
        return video
    }
    
    public class func ParseV2(jsonObject : [String:Any]) -> VideoItem? {
        
        let video = VideoItem()
        
        if let value : String = jsonObject.valueFor(key: "title") {
            video.videoTitle = value
        }
        
        if let value : String = jsonObject.valueFor(key: "thumb") {
            video.videoThumbnailUrl = value
        }
        
        if let value : String = jsonObject.valueFor(key: "url") {
            video.videoUrl = value
        }
        
        if let value : String = jsonObject.valueFor(key: "description") {
            video.videoDescription = value
        }
        
        if let value : String = jsonObject.valueFor(key: "id") {
            video.videoID = value
        }
        
        return video
    }
}

extension Dictionary {
    
    public func valueFor<T>(key:String) -> T? {
        
        if let value:Value = self[key as! Key] {
            if let value = value as? T {
                return value
            }
            else {
                return nil
            }
        }
     
        return nil
    }
    
}
