//
//  ViewController.swift
//  nelikko
//
//  Created by Ilari Lind on 29.10.15.
//  Copyright © 2015 TeamWew. All rights reserved.
//

import UIKit
import Alamofire

class BoardsViewController: UITableViewController {
    var boards: Array<String> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        Alamofire.request(.GET, "https://a.4cdn.org/boards.json")
            .responseJSON { response in
                if let JSON = response.result.value {
                    let things = JSON["boards"] as? NSArray
                    for item in things! {
                        let board = item as! Dictionary<String, AnyObject>
                        let initial: String = board["board"] as! String!
                        let title: String = board["title"]  as! String!
                        let boardName: String = "/" + initial + "/ - " + title
                        self.boards.append(boardName)
                        self.tableView.reloadData()
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
        return self.boards.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.boards[indexPath.row]
        return cell
    }
}

