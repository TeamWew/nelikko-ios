//
//  BoardsAPI.swift
//  nelikko
//
//  Created by Nicolas Arkkila on 09/11/15.
//  Copyright © 2015 TeamWew. All rights reserved.
//

import Alamofire
import Foundation
import ObjectMapper
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
                        let board = Mapper<Board>().map(item)
                        boards.append(board!)
                    }
                    completion(boards)
                }
        }
    }
}