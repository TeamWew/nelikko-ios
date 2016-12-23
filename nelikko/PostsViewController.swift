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

class PostsViewController: UITableViewController {
    var thread: Thread?
    var postLocationMap = [Int: IndexPath]()
    var posts = [Post]()
    var locationStack: [CGPoint] = []
    var backButton: UIButton?

    @IBOutlet var navBar: UINavigationItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = UIColor.white
        self.refreshControl?.tintColor = UIColor.green
        self.refreshControl?.addTarget(self, action: #selector(PostsViewController.reloadThread),
                                                for: UIControlEvents.valueChanged)
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
        guard let thread = self.thread else { return }
        ThreadAPI.getPosts(forThread: thread, withCallback: getPostsCallback)
    }

    func scrollToPost(_ number: Int) {
        guard let indexPathFound = self.postLocationMap[number] else { return }
        self.tableView.scrollToRow(at: indexPathFound, at: UITableViewScrollPosition.top, animated: true)
    }

    func scrollToExitedPost() {
        guard let scrollLocation = locationStack.popLast() else { return }
        self.tableView.setContentOffset(scrollLocation, animated: true)
        if locationStack.isEmpty {
            self.backButton?.removeFromSuperview()
            self.backButton = nil
        }
    }

    func createBackButton() {
        guard backButton == nil else { return }

        self.backButton = {
            let screenSize: CGRect = UIScreen.main.bounds
            let button: UIButton = UIButton(type: UIButtonType.custom) as UIButton
            button.frame = CGRect(x: screenSize.width - 50, y: screenSize.height - 50, width: 30, height: 30)
            button.addTarget(self, action:#selector(PostsViewController.scrollToExitedPost), for: UIControlEvents.touchUpInside)
            button.backgroundColor = UIColor.white
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 10
            button.layer.borderColor = UIColor.lightGray.cgColor
            button.setBackgroundImage(UIImage(named: "downBackButton"), for: UIControlState())
            return button
        }()
        self.parent?.view.addSubview(self.backButton!)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let post = self.posts[indexPath.row]
        guard let height = post.h, let width = post.w, post.com == nil else {
            // Let autolayout et al. handle the estimated height in case the post isn't an image-only post
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
        let adjustedHeight = CGFloat(height) * (self.view.frame.width / CGFloat(width))
        return adjustedHeight
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let requestedPost = self.posts[indexPath.row]
        let attributedString = requestedPost.attributedComment

        // Populate post's location map for later use in links
        self.postLocationMap[requestedPost.no] = indexPath

        switch requestedPost.style {
        case .ImageOnly:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostImageOnlyCell", for: indexPath) as! ThreadPostImageOnlyCell
            cell.postImageView.contentMode = .scaleAspectFit

            cell.postImageView.image = requestedPost.postImage
            if cell.postImageView?.image == nil {
                getImage(forCell: cell, post: requestedPost)
            }
            cell.postNumber?.text = String(requestedPost.no)
            return cell
        case .ImageWithText:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostImageCell", for: indexPath) as! ThreadPostWithImageCell

            cell.postImageView?.image = requestedPost.thumbnail
            if cell.postImageView?.image == nil {
                getThumbnailImage(forCell: cell, post: requestedPost)
                getImage(forCell: cell, post: requestedPost)
            }
            cell.postCommentTextView.attributedText = attributedString
            cell.postNumber?.text = String(requestedPost.no)
            cell.postCommentTextView.font = UIFont.systemFont(ofSize: 14.0)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! ThreadPostCell
            cell.postCommentTextView.attributedText = attributedString
            cell.postNumber?.text = String(requestedPost.no)
            cell.postCommentTextView.font = UIFont.systemFont(ofSize: 14.0)
            return cell
        }
    }

    private func getImage(forCell cell: PostCellWithImage?, post: Post) {
        ImageAPI.getImage(forPost: post) {[weak cell] (data: Data) in
            post.postImage = UIImage(data: data)
            DispatchQueue.main.async { cell?.postImageView?.image = post.postImage }
        }
    }

    private func getThumbnailImage(forCell cell: PostCellWithImage?, post: Post) {
        ImageAPI.getThumbnailImage(forPost: post) {[weak cell] (data: Data) in
            post.thumbnail = UIImage(data: data)
            DispatchQueue.main.async { cell?.postImageView?.image = post.thumbnail }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPost = self.posts[indexPath.row]
        guard let image = selectedPost.postImage else {
            self.tableView.deselectRow(at: indexPath, animated: false)
            return
        }
        let agWindow = Agrume(image: image)
        agWindow.showFrom(self)
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension PostsViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        let urlSplit = URL.absoluteString.characters.split(separator: ":").map(String.init)
        guard urlSplit.first == "quote" else { return false }

        let postNumberString = urlSplit.last! as NSString
        self.scrollToPost(Int(postNumberString.substring(from: 2))!)
        self.locationStack.append(self.tableView.contentOffset)
        self.createBackButton()
        return true
    }

    func paska<T>(lol: T) -> T {
        return lol
    }
}
