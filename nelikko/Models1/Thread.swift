//
//  Thread.swift
//  nelikko
//
//  Created by Nicolas Arkkila on 29/10/15.
//  Copyright © 2015 TeamWew. All rights reserved.
//

import Foundation

import CoreData

@objc(Thread)
class Thread: NSManagedObject {
    
    @NSManaged var no: Int16
    @NSManaged var last_modified: Int16

    @NSManaged var board: NSSet // Relation
    @NSManaged var posts: NSSet // Relation
}
