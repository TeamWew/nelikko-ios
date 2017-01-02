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
        self.refreshControl?.addTarget(self, action: #selector(ThreadsViewController.reloadThreads),
                                                for: UIControlEvents.valueChanged)

        self.navBar.title = self.board?.titleString
        self.reloadThreads()
    }

    func reloadThreads() {
        ThreadAPI.getAll(forBoard: self.board!) {[weak self] (threads: [Thread]) in
            self?.threads = threads
            self?.tableView.reloadData()
            self?.refreshControl?.endRefreshing()
        }
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
        if segue.identifier == "PostsSegue" {
            let destinationVC = segue.destination as? PostsViewController
            destinationVC?.thread = self.selectedThread
            self.selectedThread = nil
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ThreadCell",
                                                                  for: indexPath) as? ThreadOPCell
        else {
            return UITableViewCell()
        }

        let requestedThread = self.threads[indexPath.row]
        if let sticky = requestedThread.op.sticky {
            cell.stickyLabel.isHidden = !sticky
        } else {
            cell.stickyLabel.isHidden = true
        }

        if requestedThread.op.postImage == nil {
            cell.postImageView.image = nil

            if requestedThread.op.tim != nil {
                cell.progressView.isHidden = false

                Alamofire.request(requestedThread.op.thumbnailURL)
                    .downloadProgress(closure: { [weak cell] d in
                        cell?.progressView.progress = Float(d.fractionCompleted)
                    })
                    .responseData(completionHandler: { [weak cell] in
                        requestedThread.op.thumbnail = UIImage(data: $0.data!)
                        cell?.progressView.isHidden = true
                        DispatchQueue.main.async { cell?.postImageView?.image = requestedThread.op.thumbnail }
                    })
            }
        } else {
            cell.postImageView?.image = requestedThread.op.thumbnail
        }

        cell.firstComment.attributedText = requestedThread.op.attributedComment
        cell.firstComment.font = UIFont.systemFont(ofSize: 12.0)
        cell.subject?.text = requestedThread.op.sub
        cell.repliesLabel?.text = String(requestedThread.op.replies!) + " replies"
        cell.nameLabel?.text = requestedThread.op.name

        return cell
    }
}
