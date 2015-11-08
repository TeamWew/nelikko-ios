//
//  Board.swift
//  nelikko
//
//  Created by Nicolas Arkkila on 29/10/15.
//  Copyright © 2015 TeamWew. All rights reserved.
//

import Foundation

class Board {
    var board: String
    var bump_limit: Int16?
    var image_limit: Int16?
    var is_archived: Bool?
    var max_comment_chars: Int16?
    var max_filesize: Int16?
    var max_web_filesize: Int16?
    var meta_description: String?
    var pages: Int16?
    var per_page: Int16?
    var title: String?
    var ws_board: Bool?
    var threads: NSSet? // Relation
    
    init(board: String) {
        self.board = board
    }

    init(board: String, title: String) {
        self.title = title
        self.board = board
    }

    func getTitleString() -> String {
        return "/\(board)/ - \(title!)"
    }
}
