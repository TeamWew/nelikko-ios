//
//  ThreadOPCell.swift
//  nelikko
//
//  Created by Nicolas Arkkila on 08/11/15.
//  Copyright © 2015 TeamWew. All rights reserved.
//

import UIKit
import Foundation


protocol PostCellWithImage: class {
    var postImageView: UIImageView! { get set }
}

class ThreadOPCell : UITableViewCell, PostCellWithImage {

    @IBOutlet weak var firstComment: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
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
