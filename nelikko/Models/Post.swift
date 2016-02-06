//
//  Post.swift
//  nelikko
//
//  Created by Nicolas Arkkila on 29/10/15.
//  Copyright © 2015 TeamWew. All rights reserved.
//

import UIKit
import Foundation

class Post {
    // TODO: Cleanup

    var no: Int // numma
    var sticky: Bool
    var closed: Bool
    var name: String
    var sub: String?
    var com: String // comment
    var filename: String
    var ext: String
    var w: Int
    var h: Int
    var tn_w: Int // thumbnail
    var tn_h: Int
    var tim: Int? // renamed filename epoch
    var time: Int16 // post epoch
    var md5: String
    var fsize: Int16
    var resto: Int16 // in reply to - 0 is thread OP post
    var capcode: String // moot string
    var bumplimit: Bool // bumplimit met
    var imagelimit: Bool // imagelimit met
    var semantic_url: String // thread slug
    var replies: Int // reply count
    var images: Int16 // image count
    
    var thread: Thread?
    var thumbnail: UIImage?
    var postImage: UIImage?
    
    init(no: Int, sticky: Bool, closed: Bool, name: String, com: String, filename: String, ext: String,
        w: Int, h: Int, tn_w: Int, tn_h: Int, tim: Int, time: Int16, md5: String, fsize: Int16,
        resto: Int16, capcode: String, bumplimit: Bool, imagelimit: Bool, semantic_url: String, replies: Int, images: Int16) {
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
    
    init(no: Int, com: String, tim: Int) {
        self.no = no
        self.sticky = false
        self.closed = false
        self.name = ""
        self.com = com
        self.filename = ""
        self.ext = ""
        self.w = 0
        self.h = 0
        self.tn_w = 0
        self.tn_h = 0
        self.tim = tim
        self.time = 0
        self.md5 = ""
        self.fsize = 0
        self.resto = 0
        self.capcode = "" // not found in OP
        self.bumplimit = false
        self.imagelimit = false
        self.semantic_url = ""
        self.replies = 0
        self.images = 0
    }
    init(no: Int, com: String) {
        self.no = no
        self.sticky = false
        self.closed = false
        self.name = ""
        self.com = com
        self.filename = ""
        self.ext = ""
        self.w = 0
        self.h = 0
        self.tn_w = 0
        self.tn_h = 0
        self.tim = 0
        self.time = 0
        self.md5 = ""
        self.fsize = 0
        self.resto = 0
        self.capcode = "" // not found in OP
        self.bumplimit = false
        self.imagelimit = false
        self.semantic_url = ""
        self.replies = 0
        self.images = 0
    }

    func getAttributedComment() -> NSAttributedString? {
        let encodedData = self.com.dataUsingEncoding(NSUTF8StringEncoding)!
        do {
            let attributedString = try NSMutableAttributedString(data: encodedData, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding], documentAttributes: nil)

            let foundQuotes = self.matchesForRegexInText(">>[0-9]+", text: attributedString.string)
            for quote in foundQuotes {
                let (quoteRange, quotedPost) = quote
                let linkValue = "quote://\(quotedPost.substringFromIndex(2))"
                attributedString.addAttribute(NSLinkAttributeName, value: linkValue, range: quoteRange)
            }
            return attributedString
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }

    func getImageNameString() -> String? {
        return "\(tim!)\(ext)"
    }

    func getThumbnailImageNameString() -> String? {
        return "\(tim!)s.jpg"
    }

    func matchesForRegexInText(regex: String!, text: String!) -> [(NSRange, NSString)] {
        // TODO: move somewhere else
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = text as NSString
            let results = regex.matchesInString(text,
                options: [], range: NSMakeRange(0, nsString.length))
            return results.map { ($0.range, nsString.substringWithRange($0.range)) }
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}
