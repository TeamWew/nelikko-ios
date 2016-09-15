//
//  Post.swift
//  nelikko
//
//  Created by Nicolas Arkkila on 29/10/15.
//  Copyright © 2015 TeamWew. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper


class Post: Mappable {

    var no: Int! // numma
    var sticky: Bool?
    var closed: Bool?
    var name: String!
    var sub: String?
    var com: String! // comment
    var filename: String?
    var ext: String?
    var w: Int?
    var h: Int?
    var tn_w: Int? // thumbnail
    var tn_h: Int?
    var tim: Int? // renamed filename epoch
    var time: Int16! // post epoch
    var md5: String!
    var fsize: Int16?
    var resto: Int16? // in reply to - 0 is thread OP post
    var capcode: String? // moot string
    var bumplimit: Bool? // bumplimit met
    var imagelimit: Bool? // imagelimit met
    var semantic_url: String? // thread slug
    var replies: Int? // reply count
    var images: Int16? // image count
    
    var thread: Thread?
    var thumbnail: UIImage?
    var postImage: UIImage?

    required init?(map: Map){

    }

    func mapping(map: Map) {
        no <- map["no"]
        sticky <- map["sticky"]
        closed <- map["closed"]
        name <- map["name"]
        sub <- map["sub"]
        com <- map["com"]
        filename <- map["filename"]
        ext <- map["ext"]
        w <- map["w"]
        h <- map["h"]
        tn_w <- map["tn_w"]
        tn_h <- map["tn_h"]
        tim <- map["tim"]
        time <- map["time"]
        md5 <- map["md5"]
        fsize <- map["fsize"]
        resto <- map["resto"]
        capcode <- map["capcode"]
        bumplimit <- map["bumplimit"]
        imagelimit <- map["imagelimit"]
        semantic_url <- map["semantic_url"]
        replies <- map["replies"]
        images <- map["images"]
    }

    func getAttributedComment() -> NSAttributedString? {
        if self.com != nil {
            let encodedData = self.com.data(using: String.Encoding.utf8)!
            do {
                let attributedString = try NSMutableAttributedString(data: encodedData, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute:String.Encoding.utf8], documentAttributes: nil)
                
                let foundQuotes = self.matchesForRegexInText(">>[0-9]+", text: attributedString.string)
                for quote in foundQuotes {
                    let (quoteRange, quotedPost) = quote
                    let linkValue = "quote://\(quotedPost.substring(from: 2))"
                    attributedString.addAttribute(NSLinkAttributeName, value: linkValue, range: quoteRange)
                }
                return attributedString
            } catch let error as NSError {
                print(error.localizedDescription)
                return nil
            }
        }
        return NSAttributedString(string: "")
    }

    func getImageNameString() -> String? {
        return "\(tim!)\(ext!)"
    }

    func getThumbnailImageNameString() -> String? {
        return "\(tim!)s.jpg"
    }

    func matchesForRegexInText(_ regex: String!, text: String!) -> [(NSRange, NSString)] {
        // TODO: move somewhere else
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = text as NSString
            let results = regex.matches(in: text,
                options: [], range: NSMakeRange(0, nsString.length))
            return results.map { ($0.range, nsString.substring(with: $0.range) as NSString ) }
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}
