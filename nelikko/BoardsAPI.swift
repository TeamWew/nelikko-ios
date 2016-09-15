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

struct BoardsAPI {
    
    let url: String = "https://a.4cdn.org/boards.json"
    func getAllWithCallBack(_ completion: (([Board]) -> Void)!) {
        Alamofire.request(url).responseJSON
            { response in
                guard let boards = (response.result.value as? NSDictionary)?["boards"] as? NSArray else { return }
                completion(boards.map {b in
                    Mapper<Board>().map(JSONObject: b)!
                })
            }
    }
}

