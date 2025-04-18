//
//  SSChat.swift
//  NegoAI
//
//  Created by Michal Ukropec on 18/04/2025.
//

import SwiftUI

struct SSChat: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack {
            VStack {
                List(appState.currentMessages, id: \.self) { message in
                    MessageBubble(text: message.text, isOwn: message.isOwn)
                        .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
            }

            HStack {
                MessageField()
            }
            .padding(16)
            .background(.thinMaterial)
        }
    }
}

#Preview {
    SSChat()
        .environmentObject(AppState())
}
