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

    @IBOutlet weak var postNumber: UILabel!
    @IBOutlet weak var postCommentTextView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
