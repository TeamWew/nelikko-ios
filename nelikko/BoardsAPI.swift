//
//  BoardsAPI.swift
//  nelikko
//
//  Created by Nicolas Arkkila on 09/11/15.
//  Copyright © 2015 TeamWew. All rights reserved.
//

import Alamofire
import Foundation

class BoardsAPI {
    
    let url: String = "https://a.4cdn.org/boards.json"
    let defaults = NSUserDefaults.standardUserDefaults()
    
    func getAllWithCallBack(completion: ((Array<Board>) -> Void)!){
        // TODO: Proper serialization

        var boards: Array<Board> = []
        Alamofire.request(.GET, url)
            .responseJSON { response in
                if let JSON = response.result.value {
                    let things = JSON["boards"] as? NSArray
                    for item in things! {
                        let boardJSONItem = item as! Dictionary<String, AnyObject>
                        let ws_board = boardJSONItem["ws_board"] as! NSNumber
                        if self.defaults.boolForKey("FilterNSFW") && !Bool(ws_board) {
                            continue
                        }
                        let initial: String = boardJSONItem["board"] as! String!
                        let title: String = boardJSONItem["title"]  as! String!
                        let board = Board(board: initial, title: title)
                        board.ws_board = Bool(ws_board)

                        boards.append(board)
                    }
                    completion(boards)
                }
        }
    }
}