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

    static let url = "https://a.4cdn.org/boards.json"

    class func getAllWithCallBack(_ completion: (([Board]) -> Void)!) {
        Alamofire.request(url).responseJSON { response in
            guard let boards = (response.result.value as? NSDictionary)?["boards"] as? NSArray else { return }
            completion(boards.flatMap { Mapper<Board>().map(JSONObject: $0) })
        }
    }
}
