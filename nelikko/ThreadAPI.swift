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

                        let tim = op["tim"] as! NSNumber
                        let num = op["no"] as! NSNumber
                        let replies = op["replies"] as! NSNumber
                        let p = Post(no: num.longValue, com: comment, tim: tim.longValue)
                        if let filen = op["tim"]! {
                            p.tim = (filen as! NSNumber).longValue
                            p.ext = op["ext"] as! String
                        }
                        p.sub = subject
                        if let name = op["name"]! {
                            p.name = name as! String
                        }
                        p.replies = replies.longValue
                        let t = Thread(op: p, board: board, no: p.no)
                        p.thread = t
                        destinationThreads.append(t)
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

                        let num = post["no"] as! NSNumber
                        let p = Post(no: num.longValue, com: comment)
                        if let filen = post["tim"]! {
                                p.tim = (filen as! NSNumber).longValue
                                p.ext = post["ext"] as! String
                        }
                        p.thread = thread
                        destinationPosts.append(p)
                    }
                    }
                    completion(destinationPosts)
                }
        }
    
    func getThumbnailImage(forPost post: Post, withCallback completion: ((NSData) -> Void)) {
        let imageName = post.getImageNameString()
        var board = post.thread!.board.board
        board = board as String!
        if imageName != nil {
            let url = "https://i.4cdn.org/\(board)/\(imageName!)"
            print(url)
            Alamofire.request(.GET, url)
                .response { (request, response, data, error) in
                    guard let imageData = data else {
                        return
                    }
                    completion(imageData)
            }
        }
    }
}
