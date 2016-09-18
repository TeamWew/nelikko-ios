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

    @IBOutlet weak var nsfwFilter: UISwitch!
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        self.nsfwFilter?.isOn = self.defaults.bool(forKey: "FilterNSFW")
    }
    
    @IBAction func dismissModal(_ sender: UINavigationItem) {

        if (sender.title == "X") {
             self.dismiss(animated: true, completion: {});
        }
    }
    
    @IBAction func nsfwFilterClicked(_ sender: AnyObject) {
        self.defaults.set(self.nsfwFilter?.isOn, forKey: "FilterNSFW")
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
