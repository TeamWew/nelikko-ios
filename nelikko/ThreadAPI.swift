//
//  ThreadAPI.swift
//  nelikko
//
//  Created by Nicolas Arkkila on 09/11/15.
//  Copyright © 2015 TeamWew. All rights reserved.
//

import Foundation
import Alamofire

class ThreadAPI {

    let url: String = "https://a.4cdn.org/boards.json"
    
    func getAllForBoardWithCallback(board: String, completion: ((Array<Thread>) -> Void)!){
        // TODO: Proper serialization
        
        let url = "https://a.4cdn.org/\(board)/1.json"
        var destinationThreads: Array<Thread> = []
        Alamofire.request(.GET, url)
            .responseJSON { response in
                if let JSON = response.result.value {
                    let threads = JSON["threads"] as? NSArray
                    for thread in threads! {
                        let posts = thread["posts"] as! NSArray
                        let op = posts[0]
                        let com = op["com"] as! String
                        let tim = op["tim"] as! NSNumber
                        let num = op["no"] as! NSNumber
                        destinationThreads.append(
                            Thread(op:
                                Post(no: num.longValue, com: com, tim: tim.longValue)
                            )
                        )
                    }
                    completion(destinationThreads)
                }
        }
    }
}
