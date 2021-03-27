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
        }
    }
}
