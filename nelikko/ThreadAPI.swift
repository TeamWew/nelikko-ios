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

class ThreadAPI {

    func getAll(forBoard board: Board, withCallback completion: (([Thread]) -> Void)!){
        let url = "https://a.4cdn.org/\(board.board)/1.json"
        var destinationThreads: Array<Thread> = []
        Alamofire.request(.GET, url)
            .responseJSON { response in
                if let JSON = response.result.value as! NSDictionary? {
                    let threads = JSON["threads"] as! NSArray
                    for thread in threads {
                        
                        let posts = thread["posts"] as! NSArray
                        let op = Mapper<Post>().map(posts[0])!
                        let t = Thread(op: op, board: board, no: op.no)
                        op.thread = t
                        destinationThreads.append(t)
                    }
                    completion(destinationThreads)
                }
        }
    }

    func getPosts(forThread thread: Thread, withCallback completion: (([Post]) -> Void)!) {
        let url = "https://a.4cdn.org/\(thread.board.board)/thread/\(thread.no).json"
        var destinationPosts: Array<Post> = []
        Alamofire.request(.GET, url)
            .responseJSON { response in
                if let JSON = response.result.value {
                    let posts = JSON["posts"] as? NSArray
                    for post in posts! {
                        let p = Mapper<Post>().map(post)!
                        p.thread = thread
                        destinationPosts.append(p)
                    }
                }
                completion(destinationPosts)
            }
        }

    func getThumbnailImage(forPost post: Post, withCallback completion: ((NSData) -> Void)) {
        let imageName = post.getThumbnailImageNameString()
        var board = post.thread!.board.board
        board = board as String!
        if imageName != nil {
            let url = "https://i.4cdn.org/\(board)/\(imageName!)"
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
