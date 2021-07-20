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
    @Published var isConverting: Bool = false
    @Published var sortingKey: (keyPath: PartialKeyPath<Mp3File>, ascending: Bool)? = nil
}

extension FileListStore {
    var selectedFiles: [Mp3File] {
        selectedIndicies.map { files[$0] }
    }

    var sortedSelectedFiles: [Mp3File] {
        guard let sortingKey = sortingKey else { return selectedFiles }
        switch sortingKey.keyPath {
        case let stringKeyPath as KeyPath<Mp3File, String?>:
            return selectedFiles.sorted(by: stringKeyPath, ascending: sortingKey.ascending)
        case let intKeyPath as KeyPath<Mp3File, Int?>:
            return selectedFiles.sorted(by: intKeyPath, ascending: sortingKey.ascending)
        default:
            return selectedFiles
        }
    }
}

extension FileListStore {
    func clear() {
        selectedIndicies = []
        files = []
    }
}
