//
//  String.swift
//  mp3TagEditor
//
//  Created by 417.72KI on 2020/12/30.
//

import Foundation

extension String {
    var titlecased: String {
        replacingOccurrences(of: "([A-Z])",
                             with: " $1",
                             options: .regularExpression,
                             range: range(of: self))
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .capitalized
    }

    var lastPathComponent: String {
        (self as NSString).lastPathComponent
    }

    var pathExtension: String  {
        (self as NSString).pathExtension
    }
}
