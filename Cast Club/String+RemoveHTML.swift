//
//  String+RemoveHTML.swift
//  Cast Club
//
//  Created by Henry Macht on 12/5/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import UIKit

extension String {
    func deleteHTMLTag(tag:String) -> String {
        return self.replacingOccurrences(of: "(?i)</?\(tag)\\b[^<]*>", with: "", options: .regularExpression, range: nil)
    }
    
    func deleteHTMLTags(tags:[String]) -> String {
        var mutableString = self
        for tag in tags {
            mutableString = mutableString.deleteHTMLTag(tag: tag)
        }
        return mutableString
    }
}
