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
            ScrollViewReader { proxy in
                VStack {
                    List(appState.currentMessages, id: \.self) { message in
                        MessageBubble(text: message.text, isOwn: !message.isOwn)
                            .listRowSeparator(.hidden)
                            .id(message.id)
                    }
                    .listStyle(.plain)
                }
                .onChange(of: appState.currentMessages) { oldValue, newValue in
                    if let last = newValue.last {
                        withAnimation {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
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
