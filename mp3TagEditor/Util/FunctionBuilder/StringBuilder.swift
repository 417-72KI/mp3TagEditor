//
//  StringBuilder.swift
//  mp3TagEditor
//
//  Created by 417.72KI on 2021/03/28.
//

import Foundation

@_functionBuilder
struct StringBuilder {
    static func buildBlock(_ strings: String...) -> String {
        strings.joined()
    }

    static func buildIf(_ string: String?) -> String {
        string ?? ""
    }
}

extension String {
    init(@StringBuilder builder: () -> String) {
        self = builder()
    }
}
