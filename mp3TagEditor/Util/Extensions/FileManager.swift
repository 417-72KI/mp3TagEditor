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

    func rename(atPath path: String, to newFileName: String) throws {
        guard fileExists(atPath: path) else { return }
        let directory = path.deletingLastPathComponent
        let newFilePath = directory.appendingPathComponent(newFileName)
        try moveItem(atPath: path, toPath: newFilePath)
    }
}
