//
//  Post.swift
//  nelikko
//
//  Created by Nicolas Arkkila on 29/10/15.
//  Copyright © 2015 TeamWew. All rights reserved.
//

import Foundation

class Post {
    
    var no: Int16 // numma
    var sticky: Bool
    var closed: Bool
    var name: String
    var com: String // comment
    var filename: String
    var ext: String
    var w: Int16
    var h: Int16
    var tn_w: Int16 // thumbnail
    var tn_h: Int16
    var tim: Int16 // renamed filename epoch
    var time: Int16 // post epoch
    var md5: String
    var fsize: Int16
    var resto: Int16 // in reply to - 0 is thread OP post
    var capcode: String // moot string
    var bumplimit: Bool // bumplimit met
    var imagelimit: Bool // imagelimit met
    var semantic_url: String // thread slug
    var replies: Int16 // reply count
    var images: Int16 // image count
    
    init(no:Int16,sticky: Bool, closed: Bool, name: String, com: String, filename: String, ext: String,
        w: Int16, h: Int16, tn_w: Int16, tn_h: Int16, tim: Int16, time: Int16, md5: String, fsize: Int16,
        resto: Int16, capcode: String, bumplimit: Bool, imagelimit: Bool, semantic_url: String, replies: Int16, images: Int16) {
            self.no = no
            self.sticky = sticky
            self.closed = closed
            self.name = name
            self.com = com
            self.filename = filename
            self.ext = ext
            self.w = w
            self.h = h
            self.tn_w = tn_w
            self.tn_h = tn_h
            self.tim = tim
            self.time = time
            self.md5 = md5
            self.fsize = fsize
            self.resto = resto
            self.capcode = capcode // not found in OP
            self.bumplimit = bumplimit
            self.imagelimit = imagelimit
            self.semantic_url  = semantic_url
            self.replies = replies
            self.images = images
            
            
    }
    
    
}