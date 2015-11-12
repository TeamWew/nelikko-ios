//
//  ThreadPostCell.swift
//  nelikko
//
//  Created by Nicolas Arkkila on 11/11/15.
//  Copyright © 2015 TeamWew. All rights reserved.
//

import UIKit
import Foundation

class ThreadPostCell : UITableViewCell {

    var imageUrl: String?
    @IBOutlet var postCommentLabel: UILabel!
    @IBOutlet var postNumber: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
