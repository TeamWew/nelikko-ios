//
//  Board.swift
//  nelikko
//
//  Created by Nicolas Arkkila on 29/10/15.
//  Copyright © 2015 TeamWew. All rights reserved.
//

import Foundation
import ObjectMapper

class Board: Mappable {
    var board: String!
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
    
    required init?(map: Map){
        
    }

    func mapping(map: Map) {
        board <- map["board"]
        bump_limit <- map["bump_limit"]
        image_limit <- map["image_limit"]
        is_archived <- map["is_archived"]
        max_comment_chars <- map["max_comment_chars"]
        max_filesize <- map["max_filesize"]
        max_web_filesize <- map["max_web_filesize"]
        meta_description <- map["meta_description"]
        pages <- map["pages"]
        per_page <- map["per_page"]
        title <- map["title"]
        ws_board <- map["ws_board"]
    }
    
    func getTitleString() -> String {
        return "/\(board)/ - \(title!)"
    }
}
