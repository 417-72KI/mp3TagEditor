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
        Text(mp3File.filename(withFormat: format))
    }
}

#if DEBUG
struct FileRenamedRowView_Previews: PreviewProvider {
    static var previews: some View {
        RenamedFileRowView(
            mp3File: Mp3File.samples[0],
            format: .constant("\(FileFormat.trackNumberZeroPadding.rawValue) \(FileFormat.title.rawValue)")
        )
    }
}
#endif
