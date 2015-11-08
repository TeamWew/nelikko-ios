//
//  SettingsViewController.swift
//  nelikko
//
//  Created by Ilari Lind on 08.11.15.
//  Copyright © 2015 TeamWew. All rights reserved.
//

import UIKit
import Foundation

class SettingsViewController: UITableViewController {
    
    @IBAction func testLabel(sender: AnyObject) {
        print("test")
        self.dismissViewControllerAnimated(true, completion: {});
    }

}