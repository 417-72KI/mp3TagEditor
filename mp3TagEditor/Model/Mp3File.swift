//
//  Mp3File.swift
//  mp3TagEditor
//
//  Created by 417.72KI on 2020/12/29.
//

import Foundation
import ID3TagEditor

public struct Mp3File {
    enum Source {
        case path(String)
        case data(Data)
    }

    let source: Source
    var id3Tag: ID3Tag?

    init(path: String) throws {
        self.source = .path(path)
        self.id3Tag = try ID3TagEditor().read(from: path)
    }

    init(data: Data) throws {
        self.source = .data(data)
        self.id3Tag = try ID3TagEditor().read(mp3: data)
    }
}
