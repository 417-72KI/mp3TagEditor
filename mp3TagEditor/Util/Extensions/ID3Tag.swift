//
//  ID3Tag.swift
//  mp3TagEditor
//
//  Created by 417.72KI on 2020/12/30.
//

import Foundation
import ID3TagEditor

extension ID3Tag {
    var title: String? {
        (frames[.title] as? ID3FrameWithStringContent)?.content
    }

    var artist: String? {
        (frames[.artist] as? ID3FrameWithStringContent)?.content
    }

    var album: String? {
        (frames[.album] as? ID3FrameWithStringContent)?.content
    }
}
