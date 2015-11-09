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

    var boards = [Board]()
    let API: BoardsAPI = BoardsAPI()
    var selectedBoard: Board?


    override func viewDidLoad() {
        super.viewDidLoad()
        func getBoardsCallback(boards: Array<Board>) {
            self.boards = boards
            self.tableView.reloadData()
        }
        API.getAllWithCallBack(getBoardsCallback)
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
        let cellBoard: Board? = self.boards[indexPath.row]
        cell.textLabel?.text = cellBoard?.getTitleString()
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedBoard = self.boards[indexPath.row]
        performSegueWithIdentifier("ThreadsSegue", sender: self)
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ThreadsSegue")
        {
            let destinationVC = segue.destinationViewController as! ThreadsViewController
            destinationVC.board = self.selectedBoard
            self.selectedBoard = nil
        }
    }
    
    @IBAction func testshit(sender: AnyObject) {
        performSegueWithIdentifier("ZooSegue", sender: sender)
    }
}

