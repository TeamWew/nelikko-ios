//
//  ThreadAPI.swift
//  nelikko
//
//  Created by Nicolas Arkkila on 09/11/15.
//  Copyright © 2015 TeamWew. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import UIKit

class ThreadAPI {

    class func getAll(forBoard board: Board, withCallback completion: (([Thread]) -> Void)!){
        let url = "https://a.4cdn.org/\(board.id!)/1.json"
        Alamofire.request(url).responseJSON { response in
            if let JSON = response.result.value as? NSDictionary, let threads = JSON["threads"] as? NSArray {
                let mappedThreads = threads.map {(thread) -> Thread in
                        let th = thread as! NSDictionary
                        let posts = th["posts"] as! NSArray
                        let op = Mapper<Post>().map(JSONObject: posts.firstObject)!
                        let t = Thread(op: op, board: board, no: op.no)
                        op.thread = t
                        return t
                    }
                    completion(mappedThreads)
                }
        }
    }

    class func getPosts(forThread thread: Thread, withCallback completion: (([Post]) -> Void)!) {
        let url = "https://a.4cdn.org/\(thread.board.id!)/thread/\(thread.no).json"
        Alamofire.request(url)
            .responseJSON { response in
                guard let postsJSON = (response.result.value as? NSDictionary)?["posts"] as? NSArray else { return }
                let posts = postsJSON.map { post -> Post in
                    let p = Mapper<Post>().map(JSONObject: post)!
                    p.thread = thread
                    return p
                }
                completion(posts)
            }
        }
}
