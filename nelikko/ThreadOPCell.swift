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
    @IBOutlet var subject: UILabel!
    @IBOutlet var repliesLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!



    var imageUrl: String?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
