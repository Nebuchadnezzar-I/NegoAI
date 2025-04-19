//
//  ChatList.swift
//  NegoAI
//
//  Created by Michal Ukropec on 18/04/2025.
//

import SwiftUI

struct ChatList: View {
    @EnvironmentObject var appState: AppState

    var filteredChats: [ChatObject] {
        appState.chatList
            .filter { chat in
                appState.chatFilterText.isEmpty
                    || chat.name.localizedCaseInsensitiveContains(
                        appState.chatFilterText)
            }
            .sorted { $0.date > $1.date }
    }

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Spacer()
                NewChatButton()
            }

            ChatFilter()

            ScrollView {
                ForEach(filteredChats) { chat in
                    ChatCard(
                        name: chat.name,
                        lastMessage: chat.messages.last?.text ?? "No messages",
                        date: chat.date,
                        isActive: appState.currentChat == chat.id
                    )
                    .contentShape(Rectangle())
                    .onTapGesture {
                        appState.currentChat = chat.id
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

#Preview {
    ChatList()
        .environmentObject(AppState())
}
