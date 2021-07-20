//
//  ContentView.swift
//  mp3TagEditor
//
//  Created by 417.72KI on 2020/12/28.
//

import SwiftUI

struct ContentView: View {
    @State private var dragOver = false
    @ObservedObject var fileListStore: FileListStore

    var body: some View {
        HStack(alignment: .top) {
            Mp3TagView(mp3Files: fileListStore.selectedFiles)
            VStack {
                Mp3FileTableView(contents: $fileListStore.files,
                                 selectedIndicies: $fileListStore.selectedIndicies)
                    .onDeleteCommand {
                        logger.debug(fileListStore.selectedIndicies)
                        fileListStore.files
                            .remove(atOffsets: IndexSet(fileListStore.selectedIndicies))
                        fileListStore.selectedIndicies = []
                    }
                    .frame(minWidth: 320)
                HStack {
                    Spacer()
                    Button("リストをクリア") { fileListStore.clear() }
                }
                .padding(8)
            }
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
        .sheet(isPresented: $fileListStore.isConverting,
               onDismiss: { logger.debug("dismiss") },
               content: {
            ConvertView(convertList: fileListStore.selectedFiles,
                        isPresented: $fileListStore.isConverting)
        })
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

        guard !fileListStore.files.compactMap(\.filePath)
                .contains(url.path) else {
            logger.warning("\(url) already added.")
            return
        }
        do {
            let mp3File = try Mp3File(path: url.path)
            fileListStore.files.append(mp3File)
        } catch {
            logger.warning("\(error): \(url.path)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.hashValue) {
            ContentView(fileListStore: .init())
                .preferredColorScheme($0)
        }
    }
}
