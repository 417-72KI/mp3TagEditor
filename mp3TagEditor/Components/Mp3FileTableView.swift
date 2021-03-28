//
//  Mp3FileTableView.swift
//  mp3TagEditor
//
//  Created by 417.72KI on 2020/12/29.
//

import Cocoa
import SwiftUI

struct Mp3FileTableView: NSViewRepresentable {
    typealias NSViewType = NSScrollView

    @Environment(\.undoManager) var undoManager

    @Binding var contents: [Mp3File]
    @Binding var selectedIndicies: [Int]
    @State private var sortingKey: (PartialKeyPath<Mp3File>, Bool)?

    func makeNSView(context: Context) -> NSScrollView {
        NSScrollView().apply {
            $0.documentView = NSTableView().apply {
                Column.allCases
                    .map { column in
                        NSTableColumn(identifier: NSUserInterfaceItemIdentifier(column.rawValue))
                            .apply {
                                $0.headerCell.title = column.title
                                $0.sortDescriptorPrototype = NSSortDescriptor(
                                    key: column.rawValue,
                                    ascending: true
                                )
                            }
                    }
                    .forEach($0.addTableColumn(_:))
                $0.allowsMultipleSelection = true
                $0.dataSource = context.coordinator
                $0.delegate = context.coordinator
            }
        }
    }

    func updateNSView(_ nsView: NSScrollView, context: Context) {
        guard let tableView = nsView.documentView as? NSTableView else { return }
        context.coordinator.contents = contents
        context.coordinator.sortingKey = sortingKey

        let selectRowIndicies = selectedIndicies.map { contents[$0] }
            .compactMap(context.coordinator.sortedContents.firstIndex(of:))
            .asIndexSet()

        tableView.reloadData()

        if tableView.selectedRowIndexes != selectRowIndicies {
            tableView.selectRowIndexes(selectRowIndicies,
                                       byExtendingSelection: false)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

// MARK: - Column
extension Mp3FileTableView {
    enum Column: String, CaseIterable {
        case title
        case artist
        case album
        case albumArtist
        case track
        case filePath
    }
}

extension Mp3FileTableView.Column {
    var title: String { rawValue.titlecased }

    var keyPath: PartialKeyPath<Mp3File> {
        switch self {
        case .title: return \.title
        case .artist: return \.artist
        case .album: return \.album
        case .albumArtist: return \.albumArtist
        case .track: return \.trackPositionString
        case .filePath: return \.filePath
        }
    }
}

// MARK: - Coordinator
extension Mp3FileTableView {
    final class Coordinator: NSObject {
        var parent: Mp3FileTableView
        var contents: [Mp3File] = []
        var sortingKey: (PartialKeyPath<Mp3File>, Bool)?

        init(_ parent: Mp3FileTableView) {
            self.parent = parent
        }
    }
}

private extension Mp3FileTableView.Coordinator {
    var sortedContents: [Mp3File] {
        guard let sortingKey = sortingKey else { return contents }
        switch sortingKey.0 {
        case let stringKeyPath as KeyPath<Mp3File, String?>:
            return contents.sorted(by: stringKeyPath, ascending: sortingKey.1)
        case let intKeyPath as KeyPath<Mp3File, Int?>:
            return contents.sorted(by: intKeyPath, ascending: sortingKey.1)
        default:
            return contents
        }
    }
}

// MARK: - NSTableViewDataSource
extension Mp3FileTableView.Coordinator: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        sortedContents.count
    }

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        guard let column = tableColumn
                .map(\.identifier.rawValue)
                .flatMap(Mp3FileTableView.Column.init(rawValue:)) else { return nil }
        let content = sortedContents[row]
        switch column {
        case .title:
            return content.title
        case .artist:
            return content.artist
        case .album:
            return content.album
        case .albumArtist:
            return content.albumArtist
        case .track:
            return content.trackPositionString
        case .filePath:
            guard case let .path(filePath) = content.source else { return nil }
            return filePath
        }
    }

    func tableView(_ tableView: NSTableView, setObjectValue object: Any?, for tableColumn: NSTableColumn?, row: Int) {
        guard let newValue = object as? String,
              let tableColumn = tableColumn.map(\.identifier.rawValue)
                .flatMap(Mp3FileTableView.Column.init) else { return }
        let content = sortedContents[row]
        switch tableColumn {
        case .title:
            updateTitle(for: content, newValue)
        case .artist:
           updateArtist(for: content, newValue)
        case .album:
            updateAlbum(for: content, newValue)
        case .track:
            updateTrack(for: content, newValue)
        case .albumArtist:
            updateAlbumArtist(for: content, newValue)
        case .filePath:
            fatalError("filePath cannot modify")
        }
    }
}

private extension Mp3FileTableView.Coordinator {
    func updateTitle(for content: Mp3File, _ newValue: String?) {
        do {
            let oldTitle = content.title
            content.title = newValue
            try content.save()
            parent.undoManager?.registerUndo(withTarget: content) { [weak self] in
                self?.updateTitle(for: $0, oldTitle)
            }
        } catch {
            logger.error(error)
        }
    }

    func updateArtist(for content: Mp3File, _ newValue: String?) {
        do {
            let oldArtist = content.artist
            content.artist = newValue
            try content.save()
            parent.undoManager?.registerUndo(withTarget: content) { [weak self] in
                self?.updateArtist(for: $0, oldArtist)
            }
        } catch {
            logger.error(error)
        }
    }

    func updateAlbum(for content: Mp3File, _ newValue: String?) {
        do {
            let oldAlbum = content.album
            content.album = newValue
            try content.save()
            parent.undoManager?.registerUndo(withTarget: content) { [weak self] in
                self?.updateAlbum(for: $0, oldAlbum)
            }
        } catch {
            logger.error(error)
        }
    }

    func updateTrack(for content: Mp3File, _ newValue: String?) {
        do {
            let oldTrack = content.trackPositionString
            content.trackPositionString = newValue
            try content.save()
            parent.undoManager?.registerUndo(withTarget: content) { [weak self] in
                self?.updateTrack(for: $0, oldTrack)
            }
        } catch {
            logger.error(error)
        }
    }

    func updateAlbumArtist(for content: Mp3File, _ newValue: String?) {
        do {
            let oldAlbumArtist = content.albumArtist
            content.albumArtist = newValue
            try content.save()
            parent.undoManager?.registerUndo(withTarget: content) { [weak self] in
                self?.updateAlbumArtist(for: $0, oldAlbumArtist)
            }
        } catch {
            logger.error(error)
        }
    }
}

// MARK: - NSTableViewDelegate
extension Mp3FileTableView.Coordinator: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        true
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        guard let tableView = notification.object as? NSTableView else { return }
        let selectedRowIndexes = tableView.selectedRowIndexes
            .map { sortedContents[$0] }
            .compactMap(contents.firstIndex(of:))
        if !selectedRowIndexes.isEmpty {
            selectedRowIndexes.forEach {
                do {
                    try contents[$0].reload()
                } catch {
                    logger.error(error)
                }
            }
            parent.contents = contents
        }
        parent.selectedIndicies = selectedRowIndexes
    }

    func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        guard let sortDescriptor = tableView.sortDescriptors.first,
              let column = sortDescriptor.key
                .flatMap(Mp3FileTableView.Column.init) else { return }
        parent.sortingKey = (column.keyPath, sortDescriptor.ascending)
    }

    func tableView(_ tableView: NSTableView, shouldEdit tableColumn: NSTableColumn?, row: Int) -> Bool {
        guard let tableColumn = tableColumn.map(\.identifier.rawValue)
                .flatMap(Mp3FileTableView.Column.init) else { return false }
        switch tableColumn {
        case .filePath:
            return false
        default:
            return true
        }
    }
}

// MARK: - Preview
struct Mp3FileTableView_Previews: PreviewProvider {
    static var previews: some View {
        Mp3FileTableView(contents: .constant([]),
                         selectedIndicies: .constant([]))
    }
}
