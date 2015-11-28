//
//  PostsViewController.swift
//  nelikko
//
//  Created by Nicolas Arkkila on 11/11/15.
//  Copyright © 2015 TeamWew. All rights reserved.
//

import UIKit
import Foundation

class PostsViewController : UITableViewController {
    let API: ThreadAPI = ThreadAPI()
    var thread: Thread?
    var posts = [Post]()

    @IBOutlet var navBar: UINavigationItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBar.title = "nelikko"
        func getPostsCallback(posts: Array<Post>) {
            self.posts = posts
            self.tableView.reloadData()
        }
        API.getPosts(forThread: self.thread!, withCallback: getPostsCallback)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let requestedPost = self.posts[indexPath.row]
        if requestedPost.tim != 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("PostImageCell", forIndexPath: indexPath) as! ThreadPostWithImageCell

            func setImage(data: NSData) {
                requestedPost.postImage = UIImage(data: data)
                cell.postImageView?.image = requestedPost.postImage
            }
            if requestedPost.postImage == nil {
                API.getThumbnailImage(forPost: requestedPost, withCallback: setImage)
            }
            else {
                cell.postImageView?.image = requestedPost.postImage
            }

            cell.postCommentLabel?.attributedText = requestedPost.getAttributedComment()!
            cell.postNumber?.text = String(requestedPost.no)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("PostCell", forIndexPath: indexPath) as! ThreadPostCell

            cell.postCommentLabel?.attributedText = requestedPost.getAttributedComment()!
            cell.postNumber?.text = String(requestedPost.no)
            return cell
        }
    }

}