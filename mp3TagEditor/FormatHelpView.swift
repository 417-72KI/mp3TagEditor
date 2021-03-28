//
//  FormatHelpView.swift
//  mp3TagEditor
//
//  Created by 417.72KI on 2021/03/28.
//

import SwiftUI

struct FormatHelpView: View {
    var body: some View {
        VStack {
            ForEach(FileFormat.allCases) {
                Text($0.rawValue)
            }
        }
    }
}

struct FormatHelpView_Previews: PreviewProvider {
    static var previews: some View {
        FormatHelpView()
    }
}
