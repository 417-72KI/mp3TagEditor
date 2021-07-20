//
//  Mp3TagEditorApp.swift
//  mp3TagEditor
//
//  Created by 417.72KI on 2021/03/28.
//

import SwiftUI

@main
struct Mp3TagEditorApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @StateObject private var fileListStore = FileListStore()

    @SceneBuilder var body: some Scene {
        WindowGroup {
            ContentView(fileListStore: fileListStore)
        }.commands {
            CommandGroup(replacing: .newItem) { }
            CommandGroup(before: .newItem) {
                Button("Convert tag to file name") {
                    guard !fileListStore.selectedFiles.isEmpty,
                          !fileListStore.isConverting else { return }
                    fileListStore.isConverting.toggle()
                }
                .keyboardShortcut(KeyEquivalent("c"), modifiers: .option)
                // FIXME: not updated when any files selected
                //.disabled(fileListStore.selectedFiles.isEmpty)
                Button("Clear unknown comment") {
                    let selectedFiles = fileListStore.selectedFiles
                    guard !selectedFiles.isEmpty else { return }
                    selectedFiles.forEach {
                        $0.setComment(nil, for: .unknown)
                        do {
                            try $0.save()
                        } catch {
                            logger.error(error)
                        }
                    }
                }
            }
            CommandGroup(after: .pasteboard) {
                Button("Make the track numbers serial") {
                    let files = fileListStore.sortedSelectedFiles
                    guard !files.isEmpty else { return }
                    files.enumerated().forEach { index, file in
                        file.trackPart = (index + 1)
                        do {
                            try file.save()
                        } catch {
                            logger.error(error)
                        }
                    }
                }
            }
        }
    }
}
