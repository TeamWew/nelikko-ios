//
//  Thread.swift
//  nelikko
//
//  Created by Nicolas Arkkila on 29/10/15.
//  Copyright © 2015 TeamWew. All rights reserved.
//

import Foundation

class Thread {
    var op: Post
    var no: Int16?
    var last_modified: Int16?
    var tim: String?

    var board: Board? // Relation
    var posts: Array<Post>? // Relation
    
    init(op: Post) {
        self.op = op
    }
}
