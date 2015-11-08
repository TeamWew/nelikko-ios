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
    var board: Board?
    var threads = [Thread]()

    @IBOutlet var navBar: UINavigationItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBar.title = self.board?.getTitleString()

        Alamofire.request(.GET, "https://a.4cdn.org/g/threads.json")
            .responseJSON { response in
                if let JSON = response.result.value {
                    let pages = JSON as? NSArray
                    for page in pages! {
                        for thread in page["threads"] as! NSArray {
                            if let t = thread as? NSDictionary {
                                let no = t["no"]
                                
                                // This is how we probably want to go.
                                //let last = t["last_modified"]
                                //let newThread = FCThread(board: "g", num: no, lastModified: last)
                                //self.threads.append(newThread)
                                
                                print(no)
                                
                            }
                        }
                        /*
                        let page = page as! Dictionary<String, AnyObject>
                        
                        let board = item as! Dictionary<String, AnyObject>
                        let initial: String = board["board"] as! String!
                        let title: String = board["title"]  as! String!
                        let boardName: String = "/" + initial + "/ - " + title
                        self.threads.append(boardName)
                        self.tableView.reloadData()
                        */
                    }
                    
                }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.threads.count
    }
    
    // Click function for cells
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        //cell.textLabel?.text = self.threads[indexPath.row]
        return cell
    }
}

