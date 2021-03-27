//
//  FileFormat.swift
//  mp3TagEditor
//
//  Created by 417.72KI on 2021/03/28.
//

import Foundation

enum FileFormat: String, CaseIterable {
    case title = "%title%"
    case trackNumber = "%tracknumber%"
    case trackNumberZeroPadding = "%tracknumber_00%"
}
