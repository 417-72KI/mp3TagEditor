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
        tableView.reloadData()
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
        guard let tableColumn = tableColumn else { return nil }
        let content = sortedContents[row]
        switch Mp3FileTableView.Column(rawValue: tableColumn.identifier.rawValue) {
        case .title:
            return content.title
        case .artist:
            return content.artist
        case .album:
            return content.album
        case .filePath:
            guard case let .path(filePath) = content.source else { return nil }
            return filePath
        default:
            return nil
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
            .compactMap(parent.contents.firstIndex(of:))
        if !selectedRowIndexes.isEmpty {
            selectedRowIndexes.forEach {
                do {
                    try parent.contents[$0].reload()
                } catch {
                    logger.error(error)
                }
            }
            contents = parent.contents
        }
        parent.selectedIndicies = selectedRowIndexes
    }

    func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        guard let sortDescriptor = tableView.sortDescriptors.first,
              let column = sortDescriptor.key
                .flatMap(Mp3FileTableView.Column.init) else { return }
        parent.sortingKey = (column.keyPath, sortDescriptor.ascending)
    }
}

// MARK: - Preview
struct Mp3FileTableView_Previews: PreviewProvider {
    static var previews: some View {
        Mp3FileTableView(contents: .constant([]),
                         selectedIndicies: .constant([]))
    }
}
