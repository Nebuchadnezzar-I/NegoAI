//
//  ChatCard.swift
//  NegoAI
//
//  Created by Michal Ukropec on 18/04/2025.
//

import SwiftUI

struct ChatCard: View {
    let name: String
    let lastMessage: String
    let date: Date
    let isActive: Bool

    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f
    }()

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(name)
                    .font(.headline)
                    .foregroundColor(
                        isActive ? .white : .white.opacity(0.8))
                Spacer()
                Text(formatter.string(from: date))
                    .foregroundColor(
                        isActive ? .white.opacity(0.8) : .white.opacity(0.6))
            }
            Text(
                lastMessage.count > 30
                    ? "\(lastMessage.prefix(30))…" : lastMessage
            )
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(
                isActive ? .white.opacity(0.8) : .white.opacity(0.6))
        }
        .padding(16)
        .background(isActive ? .blue : .clear)
        .cornerRadius(8)
        .animation(.easeInOut(duration: 0.25), value: isActive)
    }
}

#Preview {
    ChatCard(
        name: "Name", lastMessage: "You last message", date: Date(),
        isActive: false
    )
    .padding(16)
}

#Preview {
    ChatCard(
        name: "Name", lastMessage: "You last message", date: Date(),
        isActive: true
    )
    .padding(16)
}
