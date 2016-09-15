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

        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = UIColor.white
        self.refreshControl?.tintColor = UIColor.green
        self.refreshControl?.addTarget(self, action: #selector(ThreadsViewController.reloadThreads), for: UIControlEvents.valueChanged)


        self.navBar.title = self.board?.getTitleString()
        self.reloadThreads()
    }

    func getThreadsCallback(_ threads: Array<Thread>) {
        self.threads = threads
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }

    func reloadThreads() {
        API.getAll(forBoard: self.board!, withCallback: getThreadsCallback)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.threads.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedThread = self.threads[(indexPath as NSIndexPath).row]
        performSegue(withIdentifier: "PostsSegue", sender: self)
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "PostsSegue")
        {
            let destinationVC = segue.destination as! PostsViewController
            destinationVC.thread = self.selectedThread
            self.selectedThread = nil
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThreadCell", for: indexPath) as! ThreadOPCell

        let requestedThread = self.threads[(indexPath as NSIndexPath).row]

        func setImage(_ data: Data) {
            requestedThread.op.postImage = UIImage(data: data)
            cell.opImageView?.image = requestedThread.op.postImage
        }

        if requestedThread.op.postImage == nil {
            cell.opImageView.image = nil
            if requestedThread.op.tim != nil {
                API.getThumbnailImage(forPost: requestedThread.op, withCallback: setImage)
            }
        }
        else {
            cell.opImageView?.image = requestedThread.op.postImage
        }


        cell.firstComment.attributedText = requestedThread.op.getAttributedComment()
        cell.firstComment.font = UIFont.systemFont(ofSize: 12.0)
        cell.subject?.text = requestedThread.op.sub
        cell.repliesLabel?.text = String(requestedThread.op.replies!) + " replies"
        cell.nameLabel?.text = requestedThread.op.name

        return cell
    }
}

