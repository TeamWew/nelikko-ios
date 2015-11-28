//
//  ThreadsViewController.swift
//  nelikko
//
//  Created by Ilari Lind on 29.10.15.
//  Copyright © 2015 TeamWew. All rights reserved.
//

import UIKit
import Alamofire

class ThreadsViewController: UITableViewController {
    let API: ThreadAPI = ThreadAPI()
    var board: Board?
    var threads = [Thread]()
    var selectedThread: Thread?

    @IBOutlet var navBar: UINavigationItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBar.title = self.board?.getTitleString()
        func getThreadsCallback(threads: Array<Thread>) {
            self.threads = threads
            self.tableView.reloadData()
        }
        API.getAll(forBoard: self.board!, withCallback: getThreadsCallback)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.threads.count
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedThread = self.threads[indexPath.row]
        performSegueWithIdentifier("PostsSegue", sender: self)
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "PostsSegue")
        {
            let destinationVC = segue.destinationViewController as! PostsViewController
            destinationVC.thread = self.selectedThread
            self.selectedThread = nil
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ThreadCell", forIndexPath: indexPath) as! ThreadOPCell

        let requestedThread = self.threads[indexPath.row]

        func setImage(data: NSData) {
            requestedThread.op.postImage = UIImage(data: data)
            cell.opImageView?.image = requestedThread.op.postImage
            self.tableView.reloadData()
        }
        if requestedThread.op.postImage == nil {
            API.getThumbnailImage(forPost: requestedThread.op, withCallback: setImage)
        }
        else {
            cell.opImageView?.image = requestedThread.op.postImage
        }


        cell.firstComment?.attributedText = requestedThread.op.getAttributedComment()
        cell.subject?.text = requestedThread.op.sub
        cell.repliesLabel?.text = String(requestedThread.op.replies) + " replies"
        cell.nameLabel?.text = requestedThread.op.name
        return cell
    }
}

