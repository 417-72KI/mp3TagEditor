//
//  FileFormat.swift
//  mp3TagEditor
//
//  Created by 417.72KI on 2021/03/28.
//

import Foundation

enum FileFormat: String, CaseIterable {
    case album = "%album%"
    case artist = "%artist%"
    case comment = "%comment%"
    case genre = "%genre%"
    case title = "%title%"
    case track = "%track%"
    case discnumber = "%discnumber%"
    //case year = "%year%"
}

extension FileFormat {
    static func numberFormatExpression(from format: Self) -> NSRegularExpression {
        try! NSRegularExpression(pattern: #"\$num\(\#(format.rawValue) *, *(?<num>[0-9]+)\)"#)
    }
}

extension FileFormat: Identifiable {
    var id: Self.RawValue { self.rawValue }
}

extension FileFormat {
    var keyPath: PartialKeyPath<Mp3File> {
        switch self {
        case .album: return \.album
           case .artist: return \.artist
           case .comment: return \.comments
           case .genre: return \.genre
           case .title: return \.title
           case .track: return \.trackPart
           case .discnumber: return \.discPart
           //case .year: return \.year
        }
    }
}
