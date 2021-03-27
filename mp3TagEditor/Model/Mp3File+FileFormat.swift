//
//  Mp3File+FileFormat.swift
//  mp3TagEditor
//
//  Created by 417.72KI on 2021/03/28.
//

import Foundation

extension Mp3File {
   func filename(withFormat format: String) -> String {
       FileFormat.allCases.reduce(format) {
           switch $1 {
           case .title:
               return $0.replacingOccurrences(of: $1.rawValue, with: title ?? "")
           case .trackNumber:
               return $0.replacingOccurrences(of: $1.rawValue, with: String(trackPart ?? 0))
           case .trackNumberZeroPadding:
               return $0.replacingOccurrences(of: $1.rawValue, with: String(format: "%02d", trackPart ?? 0))
           }
       }
   }
}
