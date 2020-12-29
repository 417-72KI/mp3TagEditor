//
//  ContentView.swift
//  mp3TagEditor
//
//  Created by 417.72KI on 2020/12/28.
//

import SwiftUI

struct ContentView: View {
    @State private var dragOver = false

    var body: some View {
        Text("Hello, World!")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onDrop(of: [kUTTypeFileURL as String],
                    isTargeted: $dragOver) { providers in
                providers.forEach { provider in
                    provider.loadItem(forTypeIdentifier: kUTTypeFileURL as String,
                                      options: nil) { data, _ in
                        guard let url = (data as? Data)
                                .flatMap({ String(data: $0, encoding: .utf8) })
                                .flatMap(URL.init) else { return }
                        do {
                            let mp3File = try Mp3File(path: url.path)
                            print(mp3File)
                        } catch {
                            print(error)
                        }
                    }
                }
                return true
            }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
