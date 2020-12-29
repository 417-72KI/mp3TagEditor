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

extension Mp3File: Equatable {
    public static func == (lhs: Mp3File, rhs: Mp3File) -> Bool {
        switch (lhs.source, rhs.source) {
        case let (.path(lPath), .path(rPath)):
            return lPath == rPath
        case let (.data(lData), .data(rData)):
            return lData == rData
        default:
            return false
        }
    }
}

// MARK: -
extension ID3Tag {
    var title: String? {
        (frames[.title] as? ID3FrameWithStringContent)?.content
    }
    var album: String? {
        (frames[.album] as? ID3FrameWithStringContent)?.content
    }
    var albumArtist: String? {
        (frames[.albumArtist] as? ID3FrameWithStringContent)?.content
    }
    var artist: String? {
        (frames[.artist] as? ID3FrameWithStringContent)?.content
    }
    var composer: String? {
        (frames[.composer] as? ID3FrameWithStringContent)?.content
    }
    var conductor: String? {
        (frames[.conductor] as? ID3FrameWithStringContent)?.content
    }
    var contentGrouping: String? {
        (frames[.contentGrouping] as? ID3FrameWithStringContent)?.content
    }
    var copyright: String? {
        (frames[.copyright] as? ID3FrameWithStringContent)?.content
    }
    var encodedBy: String? {
        (frames[.encodedBy] as? ID3FrameWithStringContent)?.content
    }
    var encoderSettings: String? {
        (frames[.encoderSettings] as? ID3FrameWithStringContent)?.content
    }
    var fileOwner: String? {
        (frames[.fileOwner] as? ID3FrameWithStringContent)?.content
    }
    var lyricist: String? {
        (frames[.lyricist] as? ID3FrameWithStringContent)?.content
    }
    var mixArtist: String? {
        (frames[.mixArtist] as? ID3FrameWithStringContent)?.content
    }
    var publisher: String? {
        (frames[.publisher] as? ID3FrameWithStringContent)?.content
    }
    var subtitle: String? {
        (frames[.subtitle] as? ID3FrameWithStringContent)?.content
    }
    var beatsPerMinute: Int? {
        (frames[.beatsPerMinute] as? ID3FrameWithIntegerContent)?.value
    }
    var originalFilename: String? {
        (frames[.originalFilename] as? ID3FrameWithStringContent)?.content
    }
    var lengthInMilliseconds: Int? {
        (frames[.lengthInMilliseconds] as? ID3FrameWithIntegerContent)?.value
    }
    var sizeInBytes: Int? {
        (frames[.sizeInBytes] as? ID3FrameWithIntegerContent)?.value
    }
    var genre: String? {
        (frames[.genre] as? ID3FrameWithStringContent)?.content
    }
    var discPosition: Int? {
        (frames[.discPosition] as? ID3FrameWithIntegerContent)?.value
    }
    var trackPosition: Int? {
        (frames[.trackPosition] as? ID3FrameWithIntegerContent)?.value
    }
    // var recordingDayMonth: String? {
    //     (frames[.recordingDayMonth] as? ID3FrameWithStringContent)?.content
    // }
    var recordingYear: String? {
        (frames[.recordingYear] as? ID3FrameWithStringContent)?.content
    }
    // var recordingHourMinute: String? {
    //     (frames[.recordingHourMinute] as? ID3FrameRecordingHourMinute)
    // }
    var recordingDateTime: RecordingDateTime? {
        (frames[.recordingDateTime] as? ID3FrameRecordingDateTime)?.recordingDateTime
    }
}
