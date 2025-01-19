//
//  Video+CoreDataProperties.swift
//  PlayBox
//
//  Created by Thejas on 19/01/25.
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

}

extension Video : Identifiable {

}
