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

    var body: some Scene {
        WindowGroup {
            ContentView()
        }.commands {
            CommandGroup(replacing: .newItem) { }
        }
    }
}
