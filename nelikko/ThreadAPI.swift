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

    func getAll(forBoard board: Board, withCallback completion: ((Array<Thread>) -> Void)!){
        // TODO: Proper serialization
        
        let url = "https://a.4cdn.org/\(board.board)/1.json"
        var destinationThreads: Array<Thread> = []
        Alamofire.request(.GET, url)
            .responseJSON { response in
                if let JSON = response.result.value {
                    let threads = JSON["threads"] as? NSArray
                    for thread in threads! {
                        let posts = thread["posts"] as! NSArray
                        let op = posts[0]
                        var comment = ""
                        if let com = op["com"]! {
                            comment = com as! String
                        }
                        var subject = ""
                        if let sub = op["sub"]! {
                            subject = sub as! String
                        }
                        let name = op["name"] as! String
                        let tim = op["tim"] as! NSNumber
                        let num = op["no"] as! NSNumber
                        let replies = op["replies"] as! NSNumber
                        let p = Post(no: num.longValue, com: comment, tim: tim.longValue)
                        p.sub = subject
                        p.name = name
                        p.replies = replies.longValue
                        destinationThreads.append(
                            Thread(op: p, board: board, no: p.no)
                        )
                    }
                    completion(destinationThreads)
                }
        }
    }
    
    func getPosts(forThread thread: Thread, withCallback completion: ((Array<Post>) -> Void)!) {
        let url = "https://a.4cdn.org/\(thread.board.board)/thread/\(thread.no).json"
        var destinationPosts: Array<Post> = []
        Alamofire.request(.GET, url)
            .responseJSON { response in
                if let JSON = response.result.value {
                    let posts = JSON["posts"] as? NSArray
                    for post in posts! {
                        var comment = ""
                        if let com = post["com"]! {
                            comment = com as! String
                        }
                        //let tim = post["tim"] as! NSNumber
                        let num = post["no"] as! NSNumber
                        let p = Post(no: num.longValue, com: comment)
                        destinationPosts.append(p)
                    }
                    }
                    completion(destinationPosts)
                }
        }
}
