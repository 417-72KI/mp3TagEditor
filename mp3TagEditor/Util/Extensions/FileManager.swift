//
//  FileManager.swift
//  mp3TagEditor
//
//  Created by 417.72KI on 2020/12/31.
//

import Foundation

extension FileManager {
    func isDirectory(atPath path: String) -> Bool {
        var isDirectory: ObjCBool = false
        guard fileExists(atPath: path, isDirectory: &isDirectory) else { return false }
        return isDirectory.boolValue
    }

    @discardableResult
    func rename(atPath path: String, to newFileName: String) throws -> String {
        guard fileExists(atPath: path) else { throw Error.notFound(path) }
        let directory = path.deletingLastPathComponent
        let newFilePath = directory.appendingPathComponent(newFileName)
        guard newFilePath != path else {
            throw Error.unmodifiedFileName(path)
        }
        try moveItem(atPath: path, toPath: newFilePath)
        return newFilePath
    }
}

extension FileManager {
    enum Error: LocalizedError {
        case notFound(String)
        case notDirectory(String)
        case unmodifiedFileName(String)
    }
}

extension FileManager.Error {
    var errorDescription: String? {
        switch self {
        case let .notFound(path):
            "\(path) not found"
        case let .notDirectory(path):
            "\(path) is not a directory"
        case let .unmodifiedFileName(path):
            "File name is not modified: \(path)"
        }
    }
}
