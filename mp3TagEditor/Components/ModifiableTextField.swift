//
//  ModifiableTextField.swift
//  mp3TagEditor
//
//  Created by 417.72KI on 2021/01/03.
//

import SwiftUI

struct ModifiableTextField: View {
    @Binding var text: String
    var modified: Bool

    var body: some View {
        HStack {
            TextField("", text: $text)
            Text(modified ? "✅" : "")
                .frame(minWidth: 19)
        }
    }
}

struct ModifiableTextField_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.hashValue) {
            Group {
                ModifiableTextField(text: .constant("hoge"), modified: true)
                ModifiableTextField(text: .constant("hoge"), modified: false)
            }
            .preferredColorScheme($0)
        }
    }
}
