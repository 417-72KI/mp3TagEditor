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
extension Mp3File {
    var filePath: String? {
        guard case let .path(filePath) = source else { return nil }
        return filePath
    }
}

// MARK: -
extension Mp3File {
    var title: String? {
        (id3Tag?.frames[.title] as? ID3FrameWithStringContent)?.content
    }
    var album: String? {
        (id3Tag?.frames[.album] as? ID3FrameWithStringContent)?.content
    }
    var albumArtist: String? {
        (id3Tag?.frames[.albumArtist] as? ID3FrameWithStringContent)?.content
    }
    var artist: String? {
        (id3Tag?.frames[.artist] as? ID3FrameWithStringContent)?.content
    }
    var composer: String? {
        (id3Tag?.frames[.composer] as? ID3FrameWithStringContent)?.content
    }
    var conductor: String? {
        (id3Tag?.frames[.conductor] as? ID3FrameWithStringContent)?.content
    }
    var contentGrouping: String? {
        (id3Tag?.frames[.contentGrouping] as? ID3FrameWithStringContent)?.content
    }
    var copyright: String? {
        (id3Tag?.frames[.copyright] as? ID3FrameWithStringContent)?.content
    }
    var encodedBy: String? {
        (id3Tag?.frames[.encodedBy] as? ID3FrameWithStringContent)?.content
    }
    var encoderSettings: String? {
        (id3Tag?.frames[.encoderSettings] as? ID3FrameWithStringContent)?.content
    }
    var fileOwner: String? {
        (id3Tag?.frames[.fileOwner] as? ID3FrameWithStringContent)?.content
    }
    var lyricist: String? {
        (id3Tag?.frames[.lyricist] as? ID3FrameWithStringContent)?.content
    }
    var mixArtist: String? {
        (id3Tag?.frames[.mixArtist] as? ID3FrameWithStringContent)?.content
    }
    var publisher: String? {
        (id3Tag?.frames[.publisher] as? ID3FrameWithStringContent)?.content
    }
    var subtitle: String? {
        (id3Tag?.frames[.subtitle] as? ID3FrameWithStringContent)?.content
    }
    var beatsPerMinute: Int? {
        (id3Tag?.frames[.beatsPerMinute] as? ID3FrameWithIntegerContent)?.value
    }
    var originalFilename: String? {
        (id3Tag?.frames[.originalFilename] as? ID3FrameWithStringContent)?.content
    }
    var lengthInMilliseconds: Int? {
        (id3Tag?.frames[.lengthInMilliseconds] as? ID3FrameWithIntegerContent)?.value
    }
    var sizeInBytes: Int? {
        (id3Tag?.frames[.sizeInBytes] as? ID3FrameWithIntegerContent)?.value
    }
    var genre: String? {
        (id3Tag?.frames[.genre] as? ID3FrameGenre)?.description
    }
    var discPosition: ID3FramePartOfTotal? {
        id3Tag?.frames[.discPosition] as? ID3FramePartOfTotal
    }
    var discPart: Int? {
        discPosition?.part
    }
    var discTotal: Int? {
        discPosition?.total
    }
    var trackPosition: ID3FramePartOfTotal? {
        id3Tag?.frames[.trackPosition] as? ID3FramePartOfTotal
    }
    var trackPart: Int? {
        trackPosition?.part
    }
    var trackTotal: Int? {
        trackPosition?.total
    }
    var recordingDateTime: RecordingDateTime? {
        (id3Tag?.frames[.recordingDateTime] as? ID3FrameRecordingDateTime)?.recordingDateTime
    }
}

extension Mp3File {
    func comment(_ language: ID3FrameContentLanguage) -> String? {
        (id3Tag?.frames[.comment(language)] as? ID3FrameWithStringContent)?.content
    }

    func thumbnail(_ pictureType: ID3PictureType) -> ID3FrameAttachedPicture? {
        id3Tag?.frames[.attachedPicture(pictureType)] as? ID3FrameAttachedPicture
    }
}

extension RecordingDateTime: Equatable {
    public static func == (lhs: RecordingDateTime, rhs: RecordingDateTime) -> Bool {
        lhs.date == rhs.date && lhs.time == rhs.time
    }
}

extension RecordingDate: Equatable {
    public static func == (lhs: RecordingDate, rhs: RecordingDate) -> Bool {
        lhs.year == rhs.year && lhs.month == rhs.month && lhs.day == rhs.day
    }
}

extension RecordingTime: Equatable {
    public static func == (lhs: RecordingTime, rhs: RecordingTime) -> Bool {
        lhs.hour == rhs.hour && lhs.minute == rhs.minute
    }
}
