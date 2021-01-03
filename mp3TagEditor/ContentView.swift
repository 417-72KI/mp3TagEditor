//
//  ContentView.swift
//  mp3TagEditor
//
//  Created by 417.72KI on 2020/12/28.
//

import SwiftUI

struct ContentView: View {
    @State private var dragOver = false
    @ObservedObject private var viewState = ViewState()

    var body: some View {
        HStack(alignment: .top) {
            Mp3TagView(mp3Files: viewState.selectedContents)
            Mp3FileTableView(contents: $viewState.files,
                             selectedContents: $viewState.selectedContents)
                .frame(minWidth: 320)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onDrop(of: [kUTTypeFileURL as String],
                isTargeted: $dragOver) { providers in
            providers.forEach { provider in
                provider.loadItem(forTypeIdentifier: kUTTypeFileURL as String,
                                  options: nil) { data, _ in
                    guard let url = (data as? Data)
                            .flatMap({ String(data: $0, encoding: .utf8) })
                            .flatMap(URL.init) else { return }
                    DispatchQueue.main.async {
                        addFiles(withUrl: url)
                    }
                }
            }
            return true
        }
    }
}

private extension ContentView {
    func addFiles(withUrl url: URL) {
        let fm = FileManager.default
        if fm.isDirectory(atPath: url.path) {
            do {
                try fm.contentsOfDirectory(atPath: url.path)
                    .map(url.appendingPathComponent(_:))
                    .forEach(addFiles(withUrl:))
            } catch {
                logger.warning("\(error): \(url.path)")
            }
            return
        }

        guard !viewState.files.compactMap(\.filePath)
                .contains(url.path) else {
            logger.warning("\(url) already added.")
            return
        }
        do {
            let mp3File = try Mp3File(path: url.path)
            viewState.files.append(mp3File)
        } catch {
            logger.warning("\(error): \(url.path)")
        }
    }
}

private extension ContentView {
    final class ViewState: ObservableObject {
        @Published var files: [Mp3File] = []
        @Published var selectedContents: [Mp3File] = []
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
