//
//  RenamedFileRowView.swift
//  mp3TagEditor
//
//  Created by 417.72KI on 2021/03/28.
//

import SwiftUI

struct RenamedFileRowView: View {
    @ObservedObject var mp3File: Mp3File
    @Binding var format: String

    var body: some View {
        HStack {
            Text(mp3File.filePath?.lastPathComponent ?? "")
            Text("→")
            Text("\(mp3File.filename(withFormat: format))")
        }
        .padding(.horizontal)
    }
}

#if DEBUG
struct FileRenamedRowView_Previews: PreviewProvider {
    static var previews: some View {
        RenamedFileRowView(
            mp3File: Mp3File.samples[0],
            format: .constant("$num(\(FileFormat.track.rawValue), 2) \(FileFormat.title.rawValue)")
        ).preferredColorScheme(.light)
        RenamedFileRowView(
            mp3File: Mp3File.samples[0],
            format: .constant("$num(\(FileFormat.track.rawValue), 2) \(FileFormat.title.rawValue)")
        ).preferredColorScheme(.dark)
    }
}
#endif
