//
//  Board.swift
//  nelikko
//
//  Created by Nicolas Arkkila on 29/10/15.
//  Copyright © 2015 TeamWew. All rights reserved.
//

import Foundation

import CoreData

@objc(Board)
class Board: NSManagedObject {
    
    @NSManaged var board: String
    @NSManaged var bump_limit: Int16
    @NSManaged var image_limit: Int16
    @NSManaged var is_archived: Bool
    @NSManaged var max_comment_chars: Int16
    @NSManaged var max_filesize: Int16
    @NSManaged var max_web_filesize: Int16
    @NSManaged var meta_description: String
    @NSManaged var pages: Int16
    @NSManaged var per_page: Int16
    @NSManaged var title: String
    @NSManaged var ws_board: Bool
    
    @NSManaged var threads: NSSet // Relation
}
