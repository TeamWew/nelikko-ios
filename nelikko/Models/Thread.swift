//
//  Thread.swift
//  nelikko
//
//  Created by Nicolas Arkkila on 29/10/15.
//  Copyright © 2015 TeamWew. All rights reserved.
//

import Foundation

class Thread {
    var op: Post! // Child
    weak var board: Board! // Parent

    var no: Int
    var last_modified: Int?
    var tim: String?

    var posts: [Post]? // Relation

    init(op: Post, board: Board, no: Int) {
        self.op = op
        self.board = board
        self.no = no
    }
}
