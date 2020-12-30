//
//  Mp3TagView.swift
//  mp3TagEditor
//
//  Created by 417.72KI on 2020/12/30.
//

import SwiftUI

struct Mp3TagView: View {
    private var mp3Files: [Mp3File]
    @ObservedObject private var viewState: ViewState = .init()

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Title")
            TextField("", text: $viewState.title)
            Text("Artist")
            TextField("", text: $viewState.artist)
            Text("Album")
            TextField("", text: $viewState.album)
            HStack {
                VStack {
                    Text("Year")
                    TextField("", text: $viewState.year)
                }
                VStack {
                    Text("Track")
                    HStack {
                        TextField("", text: $viewState.trackPart)
                        Text("/")
                        TextField("", text: $viewState.trackTotal)
                    }
                }
                VStack {
                    Text("Genre")
                    TextField("", text: $viewState.genre)
                }
            }
        }
        .frame(width: 320)
        .padding(8)
    }

    init(mp3Files: [Mp3File]) {
        self.mp3Files = mp3Files

        func singleOrMultipleValues<T: Equatable>(keyPath: KeyPath<Mp3File, T?>) -> String {
            switch mp3Files.singleOrMultipleValues(keyPath: keyPath) {
            case let .singleValue(value):
                return value.flatMap { "\($0)" } ?? ""
            case .multipleValues:
                return "(Multiple Values)"
            case .none:
                return ""
            }
        }

        viewState.title = singleOrMultipleValues(keyPath: \.title)
        viewState.artist = singleOrMultipleValues(keyPath: \.artist)
        viewState.album = singleOrMultipleValues(keyPath: \.album)
        viewState.year = singleOrMultipleValues(keyPath: \.recordingDateTime?.date?.year)
        viewState.trackPart = singleOrMultipleValues(keyPath: \.trackPart)
        viewState.trackTotal = singleOrMultipleValues(keyPath: \.trackTotal)
        viewState.genre = singleOrMultipleValues(keyPath: \.genre)
    }
}

struct Mp3TagView_Previews: PreviewProvider {
    static var previews: some View {
        Mp3TagView(mp3Files: [])
    }
}

private extension Mp3TagView {
    class ViewState: ObservableObject {
        @Published var title: String = ""
        @Published var artist: String = ""
        @Published var album: String = ""
        @Published var year: String = ""
        @Published var trackPart: String = ""
        @Published var trackTotal: String = ""
        @Published var genre: String = ""
    }
}
