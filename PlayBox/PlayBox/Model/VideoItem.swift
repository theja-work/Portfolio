//
//  VideoItem.swift
//  PlayBox
//
//  Created by Thejas on 24/01/25.
//

import Foundation
import UIKit

class VideoItem : Codable {
    
    var id : String
    var thumbnail : String
    var title : String
    var description : String
    var videoUrl : String
    
    init(id:String,thumbnail: String, title: String, description: String, videoUrl: String) {
        self.id = id
        self.thumbnail = thumbnail
        self.title = title
        self.description = description
        self.videoUrl = videoUrl
    }
    
    enum CodingKeys: String , CodingKey {
        case id
        case thumbnail = "thumb"
        case thumbnailIDAlt = "thumbnailUrl"
        case title
        case description
        case videoUrl = "url"
        case videoUrlAlt = "videoUrl"
    }
    
    required init(from decoder: any Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
        
        if let value = try? container.decode(String.self, forKey: .thumbnail) {
            self.thumbnail = value
        }
        else {
            self.thumbnail = try container.decode(String.self, forKey: .thumbnailIDAlt)
        }
        
        if let value = try? container.decode(String.self, forKey: .videoUrl) {
            self.videoUrl = value
        }
        else {
            self.videoUrl = try container.decode(String.self, forKey: .videoUrlAlt)
        }
        
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.thumbnail, forKey: .thumbnail)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.description, forKey: .description)
        try container.encode(self.videoUrl, forKey: .videoUrl)
    }
    
}
