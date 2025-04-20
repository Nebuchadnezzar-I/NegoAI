//
//  MessageBubble.swift
//  NegoAI
//
//  Created by Michal Ukropec on 18/04/2025.
//

import MarkdownUI
import SwiftUI

struct MessageBubble: View {
    let text: String
    let isOwn: Bool

    var body: some View {
        HStack {
            Markdown(text)
                .padding(10)
                .background(.red)
                .frame(maxWidth: 600)
            //                .padding(10)
            //                .background(isOwn ? .gray : .blue)
            //                .foregroundColor(.white)
            //                .clipShape(
            //                    RoundedRectangle(
            //                        cornerRadius: 16.0, style: .continuous)
            //                )
            //                .overlay(
            //                    alignment: isOwn ? .bottomLeading : .bottomTrailing
            //                ) {
            //                    Image(systemName: "arrowtriangle.down.fill")
            //                        .font(.subheadline)
            //                        .rotationEffect(
            //                            isOwn ? .degrees(45) : .degrees(-45)
            //                        )
            //                        .offset(x: isOwn ? -5 : 5, y: 5)
            //                        .foregroundColor(isOwn ? .gray : .blue)
            //                }
            //                .frame(
            //                    maxWidth: UIScreen.main.bounds.width / 2 * 0.8,
            //                    alignment: .leading)
        }
        .frame(alignment: isOwn ? .leading : .trailing)
        //        .frame(maxWidth: .infinity, alignment: isOwn ? .leading : .trailing)
        //        .padding(.horizontal)

    }
}

#Preview {
    MessageBubble(text: "Ahoj", isOwn: false)
        .padding()
}

#Preview {
    MessageBubble(text: "Ahoj", isOwn: true)
        .padding()
}
