//
//  Post.swift
//  nelikko
//
//  Created by Nicolas Arkkila on 29/10/15.
//  Copyright © 2015 TeamWew. All rights reserved.
//

import Foundation

import CoreData

@objc(Post)
class Post: NSManagedObject {
    
    @NSManaged var no: Int16 // numma
    @NSManaged var sticky: Bool
    @NSManaged var closed: Bool
    @NSManaged var name: String
    @NSManaged var com: String // comment
    @NSManaged var filename: string
    @NSManaged var ext: String
    @NSManaged var w: Int16
    @NSManaged var h: Int16
    @NSManaged var tn_w: Int16 // thumbnail
    @NSManaged var tn_h: Int16
    @NSManaged var tim: Int16 // renamed filename epoch
    @NSManaged var time: Int16 // post epoch
    @NSManaged var md5: String
    @NSManaged var fsize: Int16
    @NSManaged var resto: Int16 // in reply to - 0 is thread OP post
    @NSManaged var capcode: String // moot string
    @NSManaged var semantic_url: String
    @NSManaged var replies: Int16
    @NSManaged var images: Int16
    @NSManaged var unique_ips: Int16
    
    @NSManaged var thread: NSSet // Relation
}
