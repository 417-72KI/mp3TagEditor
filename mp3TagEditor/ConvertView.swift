//
//  ConvertView.swift
//  mp3TagEditor
//
//  Created by 417.72KI on 2021/03/28.
//

import SwiftUI

struct ConvertView: View {
    var convertList: [Mp3File]
    @Binding var isPresented: Bool
    @State var format: String = "\(FileFormat.trackNumberZeroPadding.rawValue) \(FileFormat.title.rawValue)"

    var body: some View {
        VStack {
            Text("Convert")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .bold()
                .padding(.vertical, 10)
            TextField("Format", text: $format)
            ForEach(convertList) {
                RenamedFileRowView(mp3File: $0, format: $format)
            }
            HStack {
                Button("OK") {
                    isPresented = false
                }
                Button("Cancel") {
                    isPresented = false
                }
            }.padding(8)
        }
    }
}

#if DEBUG
struct ConvertView_Previews: PreviewProvider {
    static var previews: some View {
        ConvertView(
            convertList: Mp3File.samples,
            isPresented: .constant(false)
        )
    }
}
#endif
