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
import RealmSwift

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
            self.refreshFavorites()
            self.tableView.reloadData()
        }
        API.getAllWithCallBack(getBoardsCallback)
    }
    
    func refreshFavorites() {
        self.favorites = []
        for board in boards {
            if (isFavorited(board.board)) {
                self.favorites.append(board)
            }
        }
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
    
    func indexOfFavorite(identifier: String) -> Int {
        var i = 0
        for (x, b) in self.favorites.enumerate() {
            if b.board == identifier {
                i = x
            }
        }
        return i
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
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let text = cell?.textLabel?.text!
        let boardString = String(text!)
        let boardIdentifier = boardString.characters.split{$0 == "/"}.map(String.init)[0]

        let realm = try! Realm()
        if (isFavorited(boardIdentifier)) {
            let unFavoriteAction = UITableViewRowAction(style: .Normal, title: "Unfavorite") { (rowAction:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
                let b = realm.objects(FavoritedBoard).filter("identifier == '\(boardIdentifier)'").first!
                try! realm.write {
                    realm.delete(b)
                }
                let i = self.indexOfFavorite(boardIdentifier)
                self.favorites.removeAtIndex(i)
                tableView.setEditing(false, animated: true)
                tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: i, inSection: 0)], withRowAnimation: .Automatic)
            }
            unFavoriteAction.backgroundColor = UIColor(red: 252.0/255.0, green: 0, blue: 0, alpha: 1)
            return [unFavoriteAction]
        }
        else {
            let favoriteAction = UITableViewRowAction(style: .Normal, title: "Favorite") { (rowAction:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
                try! realm.write {
                    let b = FavoritedBoard()
                    b.identifier = boardIdentifier
                    realm.add(b)
                }
                self.refreshFavorites()
                let i = self.indexOfFavorite(boardIdentifier)
                tableView.setEditing(false, animated: true)
                tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: i, inSection: 0)], withRowAnimation: .Automatic)
            }
            favoriteAction.backgroundColor = UIColor(red: 252.0/255.0, green: 194.0/255.0, blue: 0, alpha: 1) // golden
            return [favoriteAction]
            
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
    func isFavorited(identifier: String) -> Bool {
        let realm = try! Realm()
        return realm.objects(FavoritedBoard).filter("identifier == '\(identifier)'").count > 0
    }

    @IBAction func testshit(sender: AnyObject) {
        performSegueWithIdentifier("ZooSegue", sender: sender)
    }
}

