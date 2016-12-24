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

enum PostStyle {
    case ImageOnly
    case ImageWithText
    case TextOnly
}

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

    weak var thread: Thread? // Parent
    var thumbnail: UIImage?
    var postImage: UIImage?

    required init?(map: Map) {
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

    var imageNameString: String? { return "\(tim!)\(ext!)" }
    var thumbnailNameString: String? { return "\(tim!)s.jpg" }

    lazy var attributedComment: NSAttributedString = {
        guard let comment = self.com else { return NSAttributedString() }

        let attributedString = comment.html2AttributedString?.mutableCopy() as! NSMutableAttributedString
        let foundQuotes = attributedString.string.matchesForRegexInText(">>[0-9]+")

        foundQuotes.forEach { (quoteRange, quotedPost) in
            let linkValue = "quote://\(quotedPost.substring(from: 2))"
            attributedString.addAttribute(NSLinkAttributeName, value: linkValue, range: quoteRange)
        }
        return attributedString
    }()

    lazy var style: PostStyle = {
        if self.tim == nil {
            return .TextOnly
        } else if self.com == nil && self.tim != nil {
            return .ImageOnly
        }
        return .ImageWithText
    }()
}

private extension String {
    var html2AttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        return try? NSAttributedString(data: data,
                                       options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                 NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue],
                                       documentAttributes: nil)
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }

    func matchesForRegexInText(_ regex: String!) -> [(NSRange, NSString)] {
        guard let regex = try? NSRegularExpression(pattern: regex, options: []) else { return [] }

        let nsString = self as NSString
        let results = regex.matches(in: self,
                                    options: [],
                                    range: NSMakeRange(0, nsString.length))

        return results.map { ($0.range, nsString.substring(with: $0.range) as NSString ) }
    }
}
