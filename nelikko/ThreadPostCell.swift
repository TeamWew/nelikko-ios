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
    var lastKnownPosition: Double?

    @IBOutlet var postNumber: UILabel!
    @IBOutlet var postCommentTextView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
