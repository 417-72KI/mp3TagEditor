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

// MARK: -
extension Mp3File {
    var filePath: String? {
        guard case let .path(filePath) = source else { return nil }
        return filePath
    }
}

extension Mp3File {
    mutating func reload() throws {
        guard case let .path(path) = source else { return }
        id3Tag = try ID3TagEditor().read(from: path)
    }
}

// MARK: -
extension Mp3File {
    var title: String? {
        get { (id3Tag?.frames[.title] as? ID3FrameWithStringContent)?.content }
        set { logger.debug(newValue) }
    }
    var album: String? {
        get { (id3Tag?.frames[.album] as? ID3FrameWithStringContent)?.content }
        set { logger.debug(newValue) }
    }
    var albumArtist: String? {
        get { (id3Tag?.frames[.albumArtist] as? ID3FrameWithStringContent)?.content }
        set { logger.debug(newValue) }
    }
    var artist: String? {
        get { (id3Tag?.frames[.artist] as? ID3FrameWithStringContent)?.content }
        set { logger.debug(newValue) }
    }
    var composer: String? {
        get { (id3Tag?.frames[.composer] as? ID3FrameWithStringContent)?.content }
        set { logger.debug(newValue) }
    }
    var conductor: String? {
        get { (id3Tag?.frames[.conductor] as? ID3FrameWithStringContent)?.content }
        set { logger.debug(newValue) }
    }
    var contentGrouping: String? {
        get { (id3Tag?.frames[.contentGrouping] as? ID3FrameWithStringContent)?.content }
        set { logger.debug(newValue) }
    }
    var copyright: String? {
        get { (id3Tag?.frames[.copyright] as? ID3FrameWithStringContent)?.content }
        set { logger.debug(newValue) }
    }
    var encodedBy: String? {
        get { (id3Tag?.frames[.encodedBy] as? ID3FrameWithStringContent)?.content }
        set { logger.debug(newValue) }
    }
    var encoderSettings: String? {
        get { (id3Tag?.frames[.encoderSettings] as? ID3FrameWithStringContent)?.content }
        set { logger.debug(newValue) }
    }
    var fileOwner: String? {
        get { (id3Tag?.frames[.fileOwner] as? ID3FrameWithStringContent)?.content }
        set { logger.debug(newValue) }
    }
    var lyricist: String? {
        get { (id3Tag?.frames[.lyricist] as? ID3FrameWithStringContent)?.content }
        set { logger.debug(newValue) }
    }
    var mixArtist: String? {
        get { (id3Tag?.frames[.mixArtist] as? ID3FrameWithStringContent)?.content }
        set { logger.debug(newValue) }
    }
    var publisher: String? {
        get { (id3Tag?.frames[.publisher] as? ID3FrameWithStringContent)?.content }
        set { logger.debug(newValue) }
    }
    var subtitle: String? {
        get { (id3Tag?.frames[.subtitle] as? ID3FrameWithStringContent)?.content }
        set { logger.debug(newValue) }
    }
    var beatsPerMinute: Int? {
        get { (id3Tag?.frames[.beatsPerMinute] as? ID3FrameWithIntegerContent)?.value }
        set { logger.debug(newValue) }
    }
    var originalFilename: String? {
        get { (id3Tag?.frames[.originalFilename] as? ID3FrameWithStringContent)?.content }
        set { logger.debug(newValue) }
    }
    var lengthInMilliseconds: Int? {
        get { (id3Tag?.frames[.lengthInMilliseconds] as? ID3FrameWithIntegerContent)?.value }
        set { logger.debug(newValue) }
    }
    var sizeInBytes: Int? {
        get { (id3Tag?.frames[.sizeInBytes] as? ID3FrameWithIntegerContent)?.value }
        set { logger.debug(newValue) }
    }
    var genre: String? {
        get { (id3Tag?.frames[.genre] as? ID3FrameGenre)?.description }
        set { logger.debug(newValue) }
    }
    var discPosition: ID3FramePartOfTotal? {
        get { id3Tag?.frames[.discPosition] as? ID3FramePartOfTotal }
        set { logger.debug(newValue) }
    }
    var discPart: Int? {
        get { discPosition?.part }
        set { logger.debug(newValue) }
    }
    var discTotal: Int? {
        get { discPosition?.total }
        set { logger.debug(newValue) }
    }
    var trackPosition: ID3FramePartOfTotal? {
        get { id3Tag?.frames[.trackPosition] as? ID3FramePartOfTotal }
        set { logger.debug(newValue) }
    }
    var trackPart: Int? {
        get { trackPosition?.part }
        set { logger.debug(newValue) }
    }
    var trackTotal: Int? {
        get { trackPosition?.total }
        set { logger.debug(newValue) }
    }
    var recordingDateTime: RecordingDateTime? {
        get { (id3Tag?.frames[.recordingDateTime] as? ID3FrameRecordingDateTime)?.recordingDateTime }
        set { logger.debug(newValue) }
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

extension Mp3File {
    var comments: [ID3FrameContentLanguage: String] {
        ID3FrameContentLanguage.allCases
            .map { ($0, comment($0)) }
            .reduce(into: [:]) { $0[$1.0] = $1.1 }
    }

    var thumbnails: [ID3PictureType: ID3FrameAttachedPicture] {
        ID3PictureType.allCases
            .map { ($0, thumbnail($0)) }
            .reduce(into: [:]) { $0[$1.0] = $1.1 }
    }
}

// MARK: - Equatable
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
