//
//  SSChat.swift
//  NegoAI
//
//  Created by Michal Ukropec on 18/04/2025.
//

import ExyteChat
import MarkdownUI
import SwiftUI

struct SSChat: View {
    @EnvironmentObject var appState: AppState
    @State private var messages: [Message] = []

    var body: some View {
        VStack {
            //ScrollViewReader { proxy in
            //    VStack {
            //        List(appState.currentMessages, id: \.self) { message in
            //            MessageBubble(text: message.text, isOwn: !message.isOwn)
            //                .listRowSeparator(.hidden)
            //                .id(message.id)
            //        }
            //        .listStyle(.plain)
            //    }
            //    .padding(.top, 8)
            //    .onChange(of: appState.currentMessages) { oldValue, newValue in
            //        if let last = newValue.last {
            //            withAnimation {
            //                proxy.scrollTo(last.id, anchor: .bottom)
            //            }
            //        }
            //    }
            //}

            ChatView(messages: $messages, currentUser: "user1") { draft in
                let newMessage = Message(
                    userId: "user1", text: draft.text, date: Date())
                messages.append(newMessage)
            }

            //            ScrollView {
            //                ForEach(appState.currentMessages, id: \.self) { message in
            //                    VStack {
            //
            //                    }
            //                    .frame(
            //                        maxWidth: .infinity,
            //                        alignment: message.isOwn ? .trailing : .leading
            //                    )
            //                    .padding(.horizontal, 16)
            //                }
            //            }
            //            .padding(.top, 16)

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
