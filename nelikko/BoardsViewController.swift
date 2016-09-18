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
    var selectedBoard: Board?
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        BoardsAPI.getAllWithCallBack() { [weak self] (boards: [Board]) in
            self?.boards = boards
            self?.refreshFavorites()
            self?.tableView.reloadData()
        }
    }

    func refreshFavorites() {
        self.favorites = boards.filter {b in isFavorited(b.id!)}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UITableViewDelegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.favorites.count
        case 1:
            return self.boards.count
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Favorites"
        case 1:
            return "Boards"
        default:
            return nil
        }
    }
    
    func indexOfFavorite(_ identifier: String) -> Int {
        var i = 0
        for (x, b) in self.favorites.enumerated() {
            if b.id == identifier {
                i = x
            }
        }
        return i
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = indexPath.section == 0 ? self.favorites[indexPath.row].titleString : self.boards[indexPath.row].titleString
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedBoard = indexPath.section == 0 ? self.favorites[indexPath.row] : self.boards[indexPath.row]
        performSegue(withIdentifier: "ThreadsSegue", sender: self)
        self.tableView.deselectRow(at: indexPath, animated: false)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let cell = tableView.cellForRow(at: indexPath)
        let text = cell?.textLabel?.text!
        let boardString = String(text!)
        let boardIdentifier = boardString!.characters.split(separator: "/").map(String.init).first

        let realm = try! Realm()
        if (isFavorited(boardIdentifier!)) {

            let unFavoriteAction = UITableViewRowAction(style: .normal, title: "Unfavorite") { (rowAction:UITableViewRowAction, indexPath:IndexPath) -> Void in
                let b = realm.dynamicObjects("FavoritedBoard").filter("identifier == '\(boardIdentifier!)'").first!
                try! realm.write { realm.delete(b) }
                let i = self.indexOfFavorite(boardIdentifier!)
                self.favorites.remove(at: i)
                tableView.setEditing(false, animated: true)
                tableView.deleteRows(at: [IndexPath(row: i, section: 0)], with: .automatic)
            }
            unFavoriteAction.backgroundColor = UIColor(red: 252.0/255.0, green: 0, blue: 0, alpha: 1)
            return [unFavoriteAction]
        }
        else {
            let favoriteAction = UITableViewRowAction(style: .normal, title: "Favorite") { (rowAction:UITableViewRowAction, indexPath:IndexPath) -> Void in
                try! realm.write {
                    let b = FavoritedBoard()
                    b.identifier = boardIdentifier!
                    realm.add(b)
                }
                self.refreshFavorites()
                let i = self.indexOfFavorite(boardIdentifier!)
                tableView.setEditing(false, animated: true)
                tableView.insertRows(at: [IndexPath(row: i, section: 0)], with: .automatic)
            }
            favoriteAction.backgroundColor = UIColor(red: 252.0/255.0, green: 194.0/255.0, blue: 0, alpha: 1) // golden
            return [favoriteAction]
            
        }
    }

    //MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ThreadsSegue")
        {
            let destinationVC = segue.destination as! ThreadsViewController
            destinationVC.board = self.selectedBoard
            self.selectedBoard = nil
        }
    }

    //MARK: Favorites utilities
    func isFavorited(_ identifier: String) -> Bool {
        let realm = try! Realm()

        return !realm.dynamicObjects("FavoritedBoard").filter("identifier == '\(identifier)'").isEmpty

    }

    @IBAction func testshit(_ sender: AnyObject) {
        performSegue(withIdentifier: "ZooSegue", sender: sender)
    }
}

