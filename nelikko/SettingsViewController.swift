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

    @IBOutlet var nsfwFilter: UISwitch!
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        self.nsfwFilter.on = self.defaults.boolForKey("FilterNSFW")
    }
    
    @IBAction func dismissModal(sender: UINavigationItem) {

        if (sender.title == "X") {
             self.dismissViewControllerAnimated(true, completion: {});
        }
    }
    
    @IBAction func nsfwFilterClicked(sender: AnyObject) {
        if self.nsfwFilter.on {
            self.defaults.setBool(true, forKey: "FilterNSFW")
        }
        else {
            self.defaults.setBool(false, forKey: "FilterNSFW")
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