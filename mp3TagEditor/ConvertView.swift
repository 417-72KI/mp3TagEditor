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
    @State var format: String = "$num(\(FileFormat.track.rawValue), 2) \(FileFormat.title.rawValue)"
    @State var formatHelpPresented = false

    var body: some View {
        VStack {
            Text("Convert")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .bold()
                .padding(.vertical, 10)
            HStack {
                Text("Format:")
                TextField("", text: $format)
                HelpButton {
                    formatHelpPresented.toggle()
                }.popover(isPresented: $formatHelpPresented) {
                    FormatHelpView()
                }
            }
            ForEach(convertList) {
                RenamedFileRowView(mp3File: $0, format: $format)
            }
            HStack {
                Button("OK") {
                    convert()
                    isPresented = false
                }
                Spacer()
                    .frame(width: 8)
                Button("Cancel") {
                    isPresented = false
                }
            }
            .frame(alignment: .center)
        }
        .padding(8)
    }
}

private extension ConvertView {
    func convert() {
        convertList.forEach { file in
            logger.debug(file.filename(withFormat: format))
        }
    }
}

#if DEBUG
struct ConvertView_Previews: PreviewProvider {
    static var previews: some View {
        ConvertView(
            convertList: Mp3File.samples,
            isPresented: .constant(false)
        ).preferredColorScheme(.light)
        ConvertView(
            convertList: Mp3File.samples,
            isPresented: .constant(false)
        ).preferredColorScheme(.dark)
    }
}
#endif