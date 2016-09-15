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
    var postLocationMap = [Int: IndexPath]()
    var posts = [Post]()
    var previousLocation: CGPoint?
    var backButton: UIButton?

    @IBOutlet var navBar: UINavigationItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = UIColor.white
        self.refreshControl?.tintColor = UIColor.green
        self.refreshControl?.addTarget(self, action: #selector(PostsViewController.reloadThread), for: UIControlEvents.valueChanged)
        self.navBar.title = "nelikko"

        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44.0
        self.reloadThread()
    }

    func getPostsCallback(_ posts: [Post]) {
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

    func scrollToPost(_ number:Int) {
        if let indexPathFound = self.postLocationMap[number] {
            self.tableView.scrollToRow(at: indexPathFound, at: UITableViewScrollPosition.top, animated: true)
        }
    }

    func scrollToExitedPost() {
        if self.previousLocation != nil {
            self.tableView.setContentOffset(self.previousLocation!, animated: true)
            self.backButton?.removeFromSuperview()
        }
    }

    func createBackButton() {
        let screenSize: CGRect = UIScreen.main.bounds
        let button: UIButton = UIButton(type: UIButtonType.custom) as UIButton
        button.frame = CGRect(x: screenSize.width - 50, y: screenSize.height - 50, width: 30, height: 30)
        button.addTarget(self, action:#selector(PostsViewController.scrollToExitedPost), for: UIControlEvents.touchUpInside)
        button.backgroundColor = UIColor.white
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.setBackgroundImage(UIImage(named: "downBackButton"), for: UIControlState())
        self.backButton = button
        self.parent!.view.addSubview(button)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let requestedPost = self.posts[(indexPath as NSIndexPath).row]
        let attributedString = requestedPost.getAttributedComment()!

        // Populate post's location map for later use in links
        self.postLocationMap[requestedPost.no] = indexPath

        if requestedPost.com == nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostImageOnlyCell", for: indexPath) as! ThreadPostImageOnlyCell
            cell.postImageView.contentMode = .scaleAspectFit

            func setImage(_ data: Data) {
                DispatchQueue.main.async(execute: {
                    requestedPost.postImage = UIImage(data: data)
                    cell.postImageView!.image = requestedPost.postImage
                    print("assigned")
                })
            }
            if requestedPost.postImage == nil {
                cell.postImageView?.image = nil
                API.getImage(forPost: requestedPost, withCallback: setImage)
            }
            else {
                cell.postImageView?.image = requestedPost.postImage
            }
            
            return cell
        }
        else if let _ = requestedPost.tim {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostImageCell", for: indexPath) as! ThreadPostWithImageCell

            func setImage(_ data: Data) {
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
            cell.postCommentTextView.font = UIFont.systemFont(ofSize: 14.0)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! ThreadPostCell
            cell.postCommentTextView.attributedText = attributedString
            cell.postNumber?.text = String(requestedPost.no)
            cell.postCommentTextView.font = UIFont.systemFont(ofSize: 14.0)
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPost: Post = self.posts[(indexPath as NSIndexPath).row]
        self.tableView.deselectRow(at: indexPath, animated: false)
        if let _ = selectedPost.postImage {
            let imageName = selectedPost.getImageNameString()!
            let url = "https://i.4cdn.org/\(selectedPost.thread!.board.board)/\(imageName)"

            let agWindow = Agrume(imageUrl: URL(string: url)!)
            agWindow.showFrom(self)
        }
    }

}

extension PostsViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        let urlSplit = URL.absoluteString.characters.split{$0 == ":"}.map(String.init)
        if urlSplit.first! == "quote" {
            let postNumberString = urlSplit.last! as NSString
            self.scrollToPost(Int(postNumberString.substring(from: 2))!)
            self.previousLocation = self.tableView.contentOffset
            self.createBackButton()
            return false
        }
        return true
    }
}
