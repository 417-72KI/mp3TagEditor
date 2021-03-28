//
//  Mp3File+FileFormat.swift
//  mp3TagEditor
//
//  Created by 417.72KI on 2021/03/28.
//

import Foundation

extension Mp3File {
   func filename(withFormat format: String) -> String {
    String {
        lastPathComponent(withFormat: format)
        if !pathExtension.isEmpty {
            ".\(pathExtension)"
        }
    }
   }
}

extension Mp3File {
    func lastPathComponent(withFormat format: String) -> String {
        FileFormat.allCases.reduce(format) { str, fileFormat in
            switch self[keyPath: fileFormat.keyPath] {
            case let stringValue as String:
                return str.replacingOccurrences(of: fileFormat.rawValue, with: stringValue)
            case let intValue as Int:
                let str = FileFormat.numberFormatExpression(from: fileFormat)
                    .matches(in: str, range: NSRange(location: 0, length: str.count))
                    .reduce(into: str) { str, result in
                        if let range = Range(result.range, in: str),
                           let num = Range(result.range(withName: "num"), in: str)
                            .flatMap({ Int(str[$0]) }) {
                            str.replaceSubrange(range, with: String(format: "%0\(num)d", intValue))
                        }
                    }
                return str.replacingOccurrences(of: fileFormat.rawValue, with: String(intValue))
            default:
                return str
            }
        }
    }

    var pathExtension: String {
        guard let pathExtension = filePath?.pathExtension,
              !pathExtension.isEmpty else { return "" }
        return pathExtension
    }
}
