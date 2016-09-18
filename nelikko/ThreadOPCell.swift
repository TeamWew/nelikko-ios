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

    @IBOutlet weak var firstComment: UILabel!
    @IBOutlet weak var opImageView: UIImageView!
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var repliesLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var stickyLabel: UILabel!

    var imageUrl: String?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
