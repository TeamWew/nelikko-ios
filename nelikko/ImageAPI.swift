//
//  ImageAPI.swift
//  nelikko
//
//  Created by Nicolas Arkkila on 18/09/16.
//  Copyright © 2016 TeamWew. All rights reserved.
//
import Foundation
class ImageAPI {
    static let baseURL = "https://i.4cdn.org"
    class func getThumbnailImage(forPost post: Post, withCallback completion: @escaping (Data) -> Void) {
        guard let imageName = post.thumbnailNameString, let board = post.thread?.board.id else { return }
        let url = URL(string: "\(baseURL)/\(board)/\(imageName)")!
        makeRequest(url) { data in
            completion(data)
        }
    }

    class func getImage(forPost post: Post, withCallback completion: @escaping (Data) -> Void) {
        guard let imageName = post.imageNameString, let board = post.thread?.board.id else { return }
        let url = URL(string: "\(baseURL)/\(board)/\(imageName)")!
        makeRequest(url) { data in
            completion(data)
        }
    }

    private class func makeRequest(_ url: URL, completionHandler: @escaping (Data) -> Void) {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let imageData = data else {return}
            completionHandler(imageData)
        }
        task.resume()
    }
}
