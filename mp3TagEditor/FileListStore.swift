//
//  FileListStore.swift
//  mp3TagEditor
//
//  Created by 417.72KI on 2021/03/28.
//

import Foundation

final class FileListStore: ObservableObject {
    @Published var files: [Mp3File] = []
    @Published var selectedIndicies: [Int] = []
}

extension FileListStore {
    var selectedFiles: [Mp3File] {
        selectedIndicies.map { files[$0] }
    }
}
