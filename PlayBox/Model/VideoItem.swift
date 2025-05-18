//
//  VideoItem.swift
//  PlayBox
//
//  Created by Thejas on 24/01/25.
//

import Foundation
import UIKit

// Sample hls video urls
// https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8
// https://test-streams.mux.dev/test_001/stream.m3u8
// https://bitmovin-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8
// https://bitmovin-a.akamaihd.net/content/sintel/hls/playlist.m3u8
// https://content.jwplatform.com/manifests/vM7nH0Kl.m3u8
// https://content.jwplatform.com/manifests/yp34SRmf.m3u8

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
