//
//  Logger.swift
//  mp3TagEditor
//
//  Created by 417.72KI on 2020/12/31.
//

import Foundation
import XCGLogger

extension XCGLogger: Applicable {}

let logger = XCGLogger(identifier: "mp3TagEditor", includeDefaultDestinations: true).apply {
    #if DEBUG
    $0.setup(
        level: .debug,
        showLogIdentifier: true,
        showFunctionName: true,
        showThreadName: false,
        showLevel: true,
        showFileNames: true,
        showLineNumbers: true,
        showDate: true,
        writeToFile: nil,
        fileLevel: nil
    )
    #else
    $0.setup(
        level: .info,
        showLogIdentifier: true,
        showFunctionName: false,
        showThreadName: false,
        showLevel: true,
        showFileNames: false,
        showLineNumbers: false,
        showDate: true,
        writeToFile: nil,
        fileLevel: nil
    )
    #endif
}

