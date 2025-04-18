//
//  RemoveChatButton.swift
//  NegoAI
//
//  Created by Michal Ukropec on 18/04/2025.
//

import SwiftUI

struct RemoveChatButton: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        Button {
            appState.removeChat()
        } label: {
            Image(systemName: "trash")
                .imageScale(.medium)
                .foregroundStyle(.red)
        }
        .buttonStyle(.bordered)
    }
}

#Preview {
    NewChatButton()
        .environmentObject(AppState())
}
