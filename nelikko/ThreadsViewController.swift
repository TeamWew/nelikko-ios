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

    @IBOutlet var navBar: UINavigationItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBar.title = self.board?.getTitleString()
        func getThreadsCallback(threads: Array<Thread>) {
            self.threads = threads
            self.tableView.reloadData()
        }
        API.getAllForBoardWithCallback(self.board!.board, completion: getThreadsCallback)
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.threads.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ThreadCell", forIndexPath: indexPath) as! ThreadOPCell

        let requestedThread = self.threads[indexPath.row]
        cell.firstComment?.text = requestedThread.op.com
        return cell
    }
}

