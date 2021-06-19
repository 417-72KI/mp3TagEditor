//
//  Mp3File.swift
//  mp3TagEditor
//
//  Created by 417.72KI on 2020/12/29.
//

import Foundation
import ID3TagEditor

public class Mp3File: Identifiable, ObservableObject {
    enum Source {
        case path(String)
        case data(Data)
    }

    private(set) var source: Source
    private(set) var id3Tag: ID3Tag?
    private(set) var isModified: Bool

    init(path: String) throws {
        self.source = .path(path)
        self.id3Tag = try ID3TagEditor().read(from: path)
        self.isModified = false
    }

    init(data: Data) throws {
        self.source = .data(data)
        self.id3Tag = try ID3TagEditor().read(mp3: data)
        self.isModified = false
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
    func reload() throws {
        guard case let .path(path) = source else { return }
        id3Tag = try ID3TagEditor().read(from: path)
        isModified = false
    }

    func save() throws {
        guard isModified else { return }
        defer { isModified = false }

        guard let id3Tag = id3Tag else { return }
        let editor = ID3TagEditor()
        switch source {
        case let .data(data):
            source = try .data(editor.write(tag: id3Tag, mp3: data))
        case let .path(path):
            try editor.write(tag: id3Tag, to: path)
        }
    }
}

// MARK: -
extension Mp3File {
    var title: String? {
        get { (id3Tag?.frames[.title] as? ID3FrameWithStringContent)?.content }
        set {
            guard newValue != title else { return }
            id3Tag?.frames[.title] = newValue.flatMap(ID3FrameWithStringContent.init(content:))
            isModified = true
        }
    }
    var album: String? {
        get { (id3Tag?.frames[.album] as? ID3FrameWithStringContent)?.content }
        set {
            guard newValue != album else { return }
            id3Tag?.frames[.album] = newValue.flatMap(ID3FrameWithStringContent.init(content:))
            isModified = true
        }
    }
    var albumArtist: String? {
        get { (id3Tag?.frames[.albumArtist] as? ID3FrameWithStringContent)?.content }
        set {
            guard newValue != albumArtist else { return }
            id3Tag?.frames[.albumArtist] = newValue.flatMap(ID3FrameWithStringContent.init(content:))
            isModified = true
        }
    }
    var artist: String? {
        get { (id3Tag?.frames[.artist] as? ID3FrameWithStringContent)?.content }
        set {
            guard newValue != artist else { return }
            id3Tag?.frames[.artist] = newValue.flatMap(ID3FrameWithStringContent.init(content:))
            isModified = true
        }
    }
    var composer: String? {
        get { (id3Tag?.frames[.composer] as? ID3FrameWithStringContent)?.content }
        set {
            guard newValue != composer else { return }
            id3Tag?.frames[.composer] = newValue.flatMap(ID3FrameWithStringContent.init(content:))
            isModified = true
        }
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
        (id3Tag?.frames[.encodedBy] as? ID3FrameWithStringContent)?.content
    }
    var encoderSettings: String? {
        (id3Tag?.frames[.encoderSettings] as? ID3FrameWithStringContent)?.content
    }
    var fileOwner: String? {
        get { (id3Tag?.frames[.fileOwner] as? ID3FrameWithStringContent)?.content }
        // set { logger.debug(newValue) }
    }
    var lyricist: String? {
        get { (id3Tag?.frames[.lyricist] as? ID3FrameWithStringContent)?.content }
        // set { logger.debug(newValue) }
    }
    var mixArtist: String? {
        get { (id3Tag?.frames[.mixArtist] as? ID3FrameWithStringContent)?.content }
        // set { logger.debug(newValue) }
    }
    var publisher: String? {
        get { (id3Tag?.frames[.publisher] as? ID3FrameWithStringContent)?.content }
        // set { logger.debug(newValue) }
    }
    var subtitle: String? {
        get { (id3Tag?.frames[.subtitle] as? ID3FrameWithStringContent)?.content }
        // set { logger.debug(newValue) }
    }
    var beatsPerMinute: Int? {
        get { (id3Tag?.frames[.beatsPerMinute] as? ID3FrameWithIntegerContent)?.value }
        set {
            guard newValue != beatsPerMinute else { return }
            id3Tag?.frames[.beatsPerMinute] = newValue.flatMap(ID3FrameWithIntegerContent.init(value:))
            isModified = true
        }
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
        get { (id3Tag?.frames[.genre] as? ID3FrameGenre)?.description }
        set { logger.debug(newValue) }
    }
    var discPosition: ID3FramePartOfTotal? {
        get { id3Tag?.frames[.discPosition] as? ID3FramePartOfTotal }
        set {
            guard newValue != discPosition else { return }
            id3Tag?.frames[.discPosition] = newValue
            isModified = true
        }
    }
    var discPart: Int? {
        get { discPosition?.part }
        set {
            guard let newValue = newValue, newValue != discPart else { return }
            if let discPosition = discPosition {
                discPosition.part = newValue
            } else {
                discPosition = .init(part: newValue, total: nil)
            }
            isModified = true
        }
    }
    var discTotal: Int? {
        get { discPosition?.total }
        set {
            guard newValue != discTotal else { return }
            if let discPosition = discPosition {
                discPosition.total = newValue
            } else {
                discPosition = .init(part: 0, total: newValue)
            }
            isModified = true
        }
    }
    var trackPosition: ID3FramePartOfTotal? {
        get { id3Tag?.frames[.trackPosition] as? ID3FramePartOfTotal }
        set {
            guard newValue != trackPosition else { return }
            id3Tag?.frames[.trackPosition] = newValue
            isModified = true
        }
    }
    var trackPart: Int? {
        get { trackPosition?.part }
        set {
            guard let newValue = newValue, newValue != trackPart else { return }
            if let trackPosition = trackPosition {
                trackPosition.part = newValue
            } else {
                trackPosition = .init(part: newValue, total: nil)
            }
            isModified = true
        }
    }
    var trackTotal: Int? {
        get { trackPosition?.total }
        set {
            guard let newValue = newValue, newValue != trackTotal else { return }
            if let trackPosition = trackPosition {
                trackPosition.total = newValue
            } else {
                trackPosition = .init(part: 0, total: newValue)
            }
            isModified = true
        }
    }
    var recordingDateTime: RecordingDateTime? {
        get { (id3Tag?.frames[.recordingDateTime] as? ID3FrameRecordingDateTime)?.recordingDateTime }
        set { logger.debug(newValue) }
    }
    var recordingYear: Int? {
        get {
            guard let id3Tag = id3Tag else { return nil }
            switch id3Tag.properties.version {
            case .version2, .version3:
                return (id3Tag.frames[.recordingYear] as? ID3FrameWithIntegerContent)?.value
            case .version4:
                return recordingDateTime?.date?.year
            }
        }
        set {
            guard let id3Tag = id3Tag, newValue != recordingYear else { return }
            switch id3Tag.properties.version {
            case .version2, .version3:
                id3Tag.frames[.recordingYear] = ID3FrameWithIntegerContent(value: newValue)
            case .version4:
                if var recordingDate = recordingDateTime?.date {
                    recordingDate.year = newValue
                    recordingDateTime?.date = recordingDate
                } else if var recordingDateTime = recordingDateTime {
                    recordingDateTime.date = .init(day: nil, month: nil, year: newValue)
                    self.recordingDateTime = recordingDateTime
                } else {
                    recordingDateTime = .init(date: .init(day: nil, month: nil, year: newValue), time: nil)
                }
            }
            isModified = true
        }
    }
}

extension Mp3File {
    var trackPositionString: String? {
        get {
            guard let trackPosition = trackPosition else { return nil }
            return String {
                String(trackPosition.part)
                if let total = trackPosition.total {
                    "/\(total)"
                }
            }
        }
        set {
            let regex = try! NSRegularExpression(pattern: #"^(?<part>[0-9]+)(/(?<total>[0-9]+))?$"#)
            guard let newValue = newValue else {
                trackPosition = nil
                return
            }
            guard let result = regex.firstMatch(in: newValue, range: .init(location: 0, length: newValue.count)) else { return }
            guard let part = Range(result.range(withName: "part"), in: newValue)
                    .flatMap({ Int(newValue[$0]) }) else { return }
            let total = Range(result.range(withName: "total"), in: newValue)
                .flatMap { Int(newValue[$0]) }
            trackPosition = .init(part: part, total: total)
        }
    }
}

extension Mp3File {
    func comment(_ language: ID3FrameContentLanguage) -> String? {
        (id3Tag?.frames[.comment(language)] as? ID3FrameWithStringContent)?.content
    }
    func setComment(_ value: String?, for language: ID3FrameContentLanguage) {
        guard value != comment(language) else { return }
        id3Tag?.frames[.comment(language)] = value.flatMap(ID3FrameWithStringContent.init)
        isModified = true
    }
}

extension Mp3File {
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
}

extension Mp3File {
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
