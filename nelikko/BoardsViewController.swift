//
//  ViewController.swift
//  nelikko
//
//  Created by Ilari Lind on 29.10.15.
//  Copyright © 2015 TeamWew. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper


let FAV = "favoriteBoards"


class BoardsViewController: UITableViewController {

    var boards = [Board]()
    var favorites = [Board]()
    let API: BoardsAPI = BoardsAPI()
    var selectedBoard: Board?
    let defaults = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        func getBoardsCallback(boards: Array<Board>) {
            self.boards = boards
            for board in boards {
                if (isFavorited(board.getTitleString())) {
                    self.favorites.append(board)
                }
            }
            self.tableView.reloadData()
        }
        API.getAllWithCallBack(getBoardsCallback)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: UITableViewDelegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.favorites.count
        }
        else {
            return self.boards.count
        }
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Favorites"
        }
        else {
            return "Boards"
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var text: String?
        if (indexPath.section == 0) {
            text = self.favorites[indexPath.row].getTitleString()
        } else {
            text = self.boards[indexPath.row].getTitleString()
        }
        cell.textLabel?.text = text!
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selected: Board?
        if (indexPath.section == 0) {
            selected = self.favorites[indexPath.row]
        } else {
            selected = self.boards[indexPath.row]
        }
        self.selectedBoard = selected
        performSegueWithIdentifier("ThreadsSegue", sender: self)
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }

    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        // TODO: meditate NSCoding

        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let text = cell?.textLabel?.text!
        let boardString = String(text!)
        if nil == self.defaults.valueForKey(FAV) {
            self.defaults.setValue(NSArray(), forKey: FAV)
        }

        let favs = self.defaults.valueForKey(FAV) as! NSArray
        let mutableFavs = favs.mutableCopy()
        if (isFavorited(boardString)) {
            let favoriteAction = UITableViewRowAction(style: .Normal, title: "Unfavorite") { (rowAction:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
                mutableFavs.removeObjectAtIndex(favs.indexOfObject(boardString))
                self.defaults.setValue(mutableFavs, forKey: FAV)
            }
            favoriteAction.backgroundColor = UIColor(red: 252.0/255.0, green: 0, blue: 0, alpha: 1)
            return [favoriteAction]
        }
        else {
            let unFavoriteAction = UITableViewRowAction(style: .Normal, title: "Favorite") { (rowAction:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
                let newFavs = favs.arrayByAddingObject(boardString)
                self.defaults.setValue(newFavs, forKey: FAV)
            }
            unFavoriteAction.backgroundColor = UIColor(red: 252.0/255.0, green: 194.0/255.0, blue: 0, alpha: 1) // golden
            return [unFavoriteAction]
        }
    }

    //MARK: Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ThreadsSegue")
        {
            let destinationVC = segue.destinationViewController as! ThreadsViewController
            destinationVC.board = self.selectedBoard
            self.selectedBoard = nil
        }
    }
    
    //MARK: Favorites utilities
    func isFavorited(boardString: String) -> Bool {
        let favs = self.defaults.valueForKey(FAV) as! NSArray
        return favs.containsObject(boardString)
    }

    @IBAction func testshit(sender: AnyObject) {
        performSegueWithIdentifier("ZooSegue", sender: sender)
    }
}

