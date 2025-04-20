//
//  Message.swift
//  NegoAI
//
//  Created by Michal Ukropec on 20/04/2025.
//

import MarkdownUI
import SwiftUI

struct Message: View {
    let message: String
    let geo: GeometryProxy
    let sender: String

    var body: some View {
        HStack {
            if sender == "user" {
                Spacer()
            }

            Markdown(message)
                .padding(10)
                .background(sender == "user" ? .blue : .gray.opacity(0.2))
                .cornerRadius(8)

            if sender == "system" {
                Spacer()
            }
        }
        .padding(.top, 16)
        .padding(.horizontal, 16)
        .frame(maxWidth: geo.size.width / 1.2)
        .frame(
            width: geo.size.width,
            alignment: sender == "user" ? .trailing : .leading)
    }
}
