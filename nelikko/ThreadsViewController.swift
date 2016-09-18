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
    var threads = [Thread]()
    weak var board: Board?
    weak var selectedThread: Thread?

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

    func reloadThreads() {
        ThreadAPI.getAll(forBoard: self.board!) {[weak self] (threads: [Thread]) in
            self?.threads = threads
            self?.tableView.reloadData()
            self?.refreshControl?.endRefreshing()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.threads.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedThread = self.threads[indexPath.row]
        performSegue(withIdentifier: "PostsSegue", sender: self)
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "PostsSegue") {
            let destinationVC = segue.destination as? PostsViewController
            destinationVC?.thread = self.selectedThread
            self.selectedThread = nil
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThreadCell", for: indexPath) as! ThreadOPCell

        let requestedThread = self.threads[(indexPath as NSIndexPath).row]
        if let sticky = requestedThread.op.sticky {
            cell.stickyLabel.isHidden = !sticky
        }
        else {
            cell.stickyLabel.isHidden = true
        }
        if requestedThread.op.postImage == nil {
            cell.opImageView.image = nil
            if requestedThread.op.tim != nil {
                ImageAPI.getThumbnailImage(forPost: requestedThread.op) { [weak cell, weak requestedThread] (data: Data) in
                        let image = UIImage(data: data)
                        requestedThread?.op.postImage = image
                        DispatchQueue.main.sync {
                            cell?.opImageView?.image = requestedThread?.op.postImage
                        }
                }
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

