//
//  MessageBubble.swift
//  NegoAI
//
//  Created by Michal Ukropec on 18/04/2025.
//

import SwiftUI

struct MessageBubble: View {
    let text: String
    let isOwn: Bool

    var body: some View {
        HStack {
            Text(text)
                .padding(10)
                .background(isOwn ? .gray : .blue)
                .foregroundColor(.white)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 16.0, style: .continuous)
                )
                .overlay(alignment: isOwn ? .bottomLeading : .bottomTrailing) {
                    Image(systemName: "arrowtriangle.down.fill")
                        .font(.subheadline)
                        .rotationEffect(isOwn ? .degrees(45) : .degrees(-45))
                        .offset(x: isOwn ? -5 : 5, y: 5)
                        .foregroundColor(isOwn ? .gray : .blue)
                }
        }
        .frame(maxWidth: .infinity, alignment: isOwn ? .leading : .trailing)
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
