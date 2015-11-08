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
    
    @IBAction func dismissModal(sender: UINavigationItem) {
        if (sender.title == "X") {
             self.dismissViewControllerAnimated(true, completion: {});
        }
    }
    
    /*
    @IBAction func saveSwitchState(sender: AnyObject) {
        var defaults = NSUserDefaults.standardUserDefaults()
        
        if bluetoothSwitch.on {
            defaults.setBool(true, forKey: "SwitchState")
        } else {
            defaults.setBool(false, forKey: "SwitchState")
        }
    }
    */

}