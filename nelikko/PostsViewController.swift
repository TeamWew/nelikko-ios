//
//  PostsViewController.swift
//  nelikko
//
//  Created by Nicolas Arkkila on 11/11/15.
//  Copyright © 2015 TeamWew. All rights reserved.
//

import UIKit
import Foundation
import Agrume

class PostsViewController : UITableViewController {
    let API: ThreadAPI = ThreadAPI()
    var thread: Thread?
    var posts = [Post]()

    @IBOutlet var navBar: UINavigationItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = UIColor.whiteColor()
        self.refreshControl?.tintColor = UIColor.greenColor()
        self.refreshControl?.addTarget(self, action: "reloadThread", forControlEvents: UIControlEvents.ValueChanged)
        self.navBar.title = "nelikko"

        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44.0
        self.reloadThread()
    }

    func getPostsCallback(posts: Array<Post>) {
        self.posts = posts
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }

    func reloadThread() {
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
                cell.postImageView?.image = nil
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

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedPost: Post = self.posts[indexPath.row]
        if let _ = selectedPost.postImage {
            let imageName = selectedPost.getImageNameString()!
            let url = "https://i.4cdn.org/\(selectedPost.thread!.board.board)/\(imageName)"
            let agrume = Agrume(imageURL: NSURL(string: url)!)
            agrume.showFrom(self)
        }
        else {
            self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
        }
    }

}
