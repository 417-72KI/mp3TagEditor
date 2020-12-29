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

    func makeNSView(context: Context) -> NSScrollView {
        NSScrollView().apply {
            $0.documentView = NSTableView().apply {
                Column.allCases
                    .map { column in
                        NSTableColumn(identifier: NSUserInterfaceItemIdentifier(column.rawValue)).apply {
                            $0.headerCell.title = column.title
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
        tableView.reloadData()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
}

extension Mp3FileTableView {
    enum Column: String, CaseIterable {
        case title
        case artist
        case album
        case filePath
    }
}

extension Mp3FileTableView.Column {
    var title: String { rawValue.titlecased }
}

extension Mp3FileTableView {
    final class Coordinator: NSObject {
        var contents: [Mp3File] = []
    }
}

extension Mp3FileTableView.Coordinator: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        contents.count
    }

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        guard let tableColumn = tableColumn else { return nil }
        let content = contents[row]
        switch Mp3FileTableView.Column(rawValue: tableColumn.identifier.rawValue) {
        case .title:
            return content.id3Tag?.title
        case .artist:
            return content.id3Tag?.artist
        case .album:
            return content.id3Tag?.album
        case .filePath:
            guard case let .path(filePath) = content.source else { return nil }
            return filePath
        default:
            return nil
        }
    }
}

extension Mp3FileTableView.Coordinator: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        true
    }
}
