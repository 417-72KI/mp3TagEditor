//
//  HelpButton.swift
//  mp3TagEditor
//
//  Created by 417.72KI on 2021/03/28.
//

import SwiftUI

// https://blog.urtti.com/creating-a-macos-help-button-in-swiftui
struct HelpButton: View {
    var action : () -> Void

    var body: some View {
        Button(action: action, label: {
            ZStack {
                Circle()
                    .strokeBorder(Color(NSColor.separatorColor), lineWidth: 0.5)
                    .background(Circle().foregroundColor(Color(NSColor.controlColor)))
                    .shadow(color: Color(NSColor.separatorColor).opacity(0.3), radius: 1)
                    .frame(width: 20, height: 20)
                Text("?").font(.system(size: 15, weight: .medium ))
            }
        })
        .buttonStyle(PlainButtonStyle())
    }
}

struct HelpButton_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.hashValue) {
            HelpButton(action: {})
                .padding()
                .preferredColorScheme($0)
        }
    }
}
