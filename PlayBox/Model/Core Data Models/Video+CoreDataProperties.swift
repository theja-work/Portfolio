//
//  Video+CoreDataProperties.swift
//  PlayBox
//
//  Created by Thejas on 24/01/25.
//
//

import Foundation
import CoreData


extension Video {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Video> {
        return NSFetchRequest<Video>(entityName: "Video")
    }

    @NSManaged public var videoName: String?
    @NSManaged public var videoUrl: String?
    @NSManaged public var thumbnail: String?
    @NSManaged public var videoDescription: String?
    @NSManaged public var lastPosition: Double
    @NSManaged public var id: String?

}

extension Video : Identifiable {
    
    func convertToVideoModel() -> VideoItem? {
        
        guard let id = self.id , let thumbnail = self.thumbnail , let title = self.videoName , let description = self.videoDescription , let url = self.videoUrl else {return nil}
        
        return VideoItem(id:id, thumbnail: thumbnail, title: title, description: description, videoUrl: url)
        
    }
}
