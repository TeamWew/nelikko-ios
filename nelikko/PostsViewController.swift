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

class PostsViewController : UITableViewController, UITextViewDelegate {
    let API: ThreadAPI = ThreadAPI()
    var thread: Thread?
    var postLocationMap = [Int: NSIndexPath]()
    var posts = [Post]()
    var previousLocation: CGPoint?
    var backButton: UIButton?

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

    func scrollToPost(number:Int) {
        if let indexPathFound = self.postLocationMap[number] {
            self.tableView.scrollToRowAtIndexPath(indexPathFound, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        }
    }

    func scrollToExitedPost() {
        if self.previousLocation != nil {
            self.tableView.setContentOffset(self.previousLocation!, animated: true)
            self.backButton?.removeFromSuperview()
        }
    }

    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        let urlSplit = URL.absoluteString.characters.split{$0 == ":"}.map(String.init)
        if urlSplit.first! == "quote" {
            let postNumberString = urlSplit.last! as NSString
            self.scrollToPost(Int(postNumberString.substringFromIndex(2))!)
            self.previousLocation = self.tableView.contentOffset
            self.createBackButton()
            return false
        }
        return true

    }

    func createBackButton() {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let button: UIButton = UIButton(type: UIButtonType.Custom) as UIButton
        button.frame = CGRectMake(screenSize.width - 50, screenSize.height - 50, 30, 30)
        button.addTarget(self, action:"scrollToExitedPost", forControlEvents: UIControlEvents.TouchUpInside)
        button.backgroundColor = UIColor.whiteColor()
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.lightGrayColor().CGColor
        button.setBackgroundImage(UIImage(named: "downBackButton"), forState: UIControlState.Normal)
        self.backButton = button
        self.parentViewController!.view.addSubview(button)
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let requestedPost = self.posts[indexPath.row]
        let attributedString = requestedPost.getAttributedComment()!

        // Populate post's location map for later use in links
        self.postLocationMap[requestedPost.no] = indexPath

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
            cell.postCommentTextView.attributedText = attributedString
            cell.postNumber?.text = String(requestedPost.no)
            cell.postCommentTextView.font = UIFont.systemFontOfSize(14.0)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("PostCell", forIndexPath: indexPath) as! ThreadPostCell
            cell.postCommentTextView.attributedText = attributedString
            cell.postNumber?.text = String(requestedPost.no)
            cell.postCommentTextView.font = UIFont.systemFontOfSize(14.0)
            return cell
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedPost: Post = self.posts[indexPath.row]
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
        if let _ = selectedPost.postImage {
            let imageName = selectedPost.getImageNameString()!
            let url = "https://i.4cdn.org/\(selectedPost.thread!.board.board)/\(imageName)"
            let agrume = Agrume(imageURL: NSURL(string: url)!)
            agrume.showFrom(self)
        }
    }

}
