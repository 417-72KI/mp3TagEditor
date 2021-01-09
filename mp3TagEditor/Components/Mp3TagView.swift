//
//  Mp3TagView.swift
//  mp3TagEditor
//
//  Created by 417.72KI on 2020/12/30.
//

import SwiftUI

struct Mp3TagView: View {
    private var mp3Files: [Mp3File]
    @ObservedObject private var viewState: ViewState

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Group {
                Text("Title")
                ModifiableTextField(text: $viewState.title,
                                    modified: viewState.titleModified)
                Text("Artist")
                ModifiableTextField(text: $viewState.artist,
                                    modified: viewState.artistModified)
                Text("Album")
                ModifiableTextField(text: $viewState.album,
                                    modified: viewState.albumModified)
            }
            Group {
                Text("Year")
                ModifiableTextField(text: $viewState.year,
                                    modified: viewState.yearModified)
                Text("Track")
                HStack {
                    ModifiableTextField(text: $viewState.trackPart,
                                        modified: viewState.trackPartModified)
                    Text("/")
                    ModifiableTextField(text: $viewState.trackTotal,
                                        modified: viewState.trackTotalModified)
                    Spacer(minLength: 180)
                }
                Text("Genre")
                ModifiableTextField(text: $viewState.genre,
                                    modified: viewState.genreModified)
            }
            Group {
                Text("Comment")
                ModifiableTextField(text: $viewState.comment,
                                    modified: viewState.commentModified)
                Text("Composer")
                ModifiableTextField(text: $viewState.composer,
                                    modified: viewState.composerModified)
                Text("Disc")
                HStack {
                    ModifiableTextField(text: $viewState.discPart,
                                        modified: viewState.discPartModified)
                    Text("/")
                    ModifiableTextField(text: $viewState.discTotal,
                                        modified: viewState.discTotalModified)
                    Spacer(minLength: 180)
                }
            }
            Group {
                Text("Thumbnail")
                ZStack {
                    if let thumbnail = viewState.thumbnail
                        .flatMap(NSImage.init(data:)) {
                        Image(nsImage: thumbnail)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                }.frame(width: 120, height: 120, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .padding(8)
                .border(Color.secondary, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
            }
        }
        .frame(width: 320)
        .padding(8)
    }

    init(mp3Files: [Mp3File]) {
        self.mp3Files = mp3Files
        viewState = .init(mp3Files: mp3Files)
    }
}

struct Mp3TagView_Previews: PreviewProvider {
    static var previews: some View {
        Mp3TagView(mp3Files: [])
    }
}

private extension Mp3TagView {
    class ViewState: ObservableObject {
        @Published var title: String
        @Published var artist: String
        @Published var album: String
        @Published var year: String
        @Published var trackPart: String
        @Published var trackTotal: String
        @Published var genre: String
        @Published var comment: String
        @Published var albumArtist: String
        @Published var composer: String
        @Published var discPart: String
        @Published var discTotal: String
        @Published var thumbnail: Data?

        private let initialValue: InitialValue
        private let isEmpty: Bool

        init(mp3Files: [Mp3File]) {
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
            initialValue = .init(
                title: singleOrMultipleValues(keyPath: \.title),
                artist: singleOrMultipleValues(keyPath: \.artist),
                album: singleOrMultipleValues(keyPath: \.album),
                year: singleOrMultipleValues(keyPath: \.recordingDateTime?.date?.year),
                trackPart: singleOrMultipleValues(keyPath: \.trackPart),
                trackTotal: singleOrMultipleValues(keyPath: \.trackTotal),
                genre: singleOrMultipleValues(keyPath: \.genre),
                comment: {
                    switch mp3Files.singleOrMultipleValues({ $0.comment(.eng) }) {
                    case let .singleValue(value):
                        return value.flatMap { "\($0)" } ?? ""
                    case .multipleValues:
                        return "(Multiple Values)"
                    case .none:
                        return ""
                    }
                }(),
                albumArtist: singleOrMultipleValues(keyPath: \.albumArtist),
                composer: singleOrMultipleValues(keyPath: \.composer),
                discPart: singleOrMultipleValues(keyPath: \.discPart),
                discTotal: singleOrMultipleValues(keyPath: \.discTotal),
                thumbnail: {
                    logger.debug(mp3Files.singleOrMultipleValues(\.thumbnails))
                    switch mp3Files.singleOrMultipleValues({ $0.thumbnail(.other) }) {
                    case let .singleValue(value):
                        return value.map(\.picture)
                    case .multipleValues, .none:
                        return nil
                    }
                }()
            )
            title = initialValue.title
            artist = initialValue.artist
            album = initialValue.album
            year = initialValue.year
            trackPart = initialValue.trackPart
            trackTotal = initialValue.trackTotal
            genre = initialValue.genre
            comment = initialValue.comment
            albumArtist = initialValue.albumArtist
            composer = initialValue.composer
            discPart = initialValue.discPart
            discTotal = initialValue.discTotal
            thumbnail = initialValue.thumbnail
            isEmpty = mp3Files.isEmpty
        }
    }
}

extension Mp3TagView.ViewState {
    struct InitialValue {
        var title: String
        var artist: String
        var album: String
        var year: String
        var trackPart: String
        var trackTotal: String
        var genre: String
        var comment: String
        var albumArtist: String
        var composer: String
        var discPart: String
        var discTotal: String
        var thumbnail: Data?
    }
}

extension Mp3TagView.ViewState {
    var titleModified: Bool {
        !isEmpty && title != initialValue.title
    }
    var artistModified: Bool {
        !isEmpty && artist != initialValue.artist
    }
    var albumModified: Bool {
        !isEmpty && album != initialValue.album
    }
    var yearModified: Bool {
        !isEmpty && year != initialValue.year
    }
    var trackPartModified: Bool {
        !isEmpty && trackPart != initialValue.trackPart
    }
    var trackTotalModified: Bool {
        !isEmpty && trackTotal != initialValue.trackTotal
    }
    var genreModified: Bool {
        !isEmpty && genre != initialValue.genre
    }
    var commentModified: Bool {
        !isEmpty && comment != initialValue.comment
    }
    var albumArtistModified: Bool {
        !isEmpty && albumArtist != initialValue.albumArtist
    }
    var composerModified: Bool {
        !isEmpty && composer != initialValue.composer
    }
    var discPartModified: Bool {
        !isEmpty && discPart != initialValue.discPart
    }
    var discTotalModified: Bool {
        !isEmpty && discTotal != initialValue.discTotal
    }
}
