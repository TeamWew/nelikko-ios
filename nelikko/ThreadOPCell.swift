//
//  ThreadOPCell.swift
//  nelikko
//
//  Created by Nicolas Arkkila on 08/11/15.
//  Copyright © 2015 TeamWew. All rights reserved.
//

import UIKit
import Foundation

class ThreadOPCell : UITableViewCell {

    @IBOutlet var firstComment: UILabel!
    @IBOutlet var opImageView: UIImageView!
    var imageUrl: String?

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}