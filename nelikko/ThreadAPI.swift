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

    func getPosts(forThread thread: Thread, withCallback completion: (([Post]) -> Void)!) {
        let url = "https://a.4cdn.org/\(thread.board.board)/thread/\(thread.no).json"
        var destinationPosts: Array<Post> = []
        Alamofire.request(url)
            .responseJSON { response in
                if let JSON = response.result.value as? NSDictionary {
                    let posts = JSON["posts"] as? NSArray
                    for post in posts! {
                        let p = Mapper<Post>().map(JSONObject: post)!
                        p.thread = thread
                        destinationPosts.append(p)
                    }
                }
                completion(destinationPosts)
            }
        }

    func getThumbnailImage(forPost post: Post, withCallback completion: @escaping ((Data) -> Void)) {
        guard let imageName = post.getThumbnailImageNameString(), let board = post.thread?.board.board else { return }
        let url = "https://i.4cdn.org/\(board)/\(imageName)"
        Alamofire.download(url)
            .responseData { response in
                guard let imageData = response.result.value else { return }
                completion(imageData)
            }
    }

    func getImage(forPost post: Post, withCallback completion: @escaping ((Data) -> Void)) {
        guard let imageName = post.getImageNameString(), let board = post.thread?.board.board else { return }
        let url = "https://i.4cdn.org/\(board)/\(imageName)"
        Alamofire.download(url)
            .responseData { response in
                guard let imageData = response.result.value else { return }
                completion(imageData)
        }
    }
}
