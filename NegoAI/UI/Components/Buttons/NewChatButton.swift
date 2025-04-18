//
//  NewChatButton.swift
//  NegoAI
//
//  Created by Michal Ukropec on 18/04/2025.
//

import SwiftUI

struct NewChatButton: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        Button {
            appState.addNewChat()
        } label: {
            Image(systemName: "plus.bubble")
                .imageScale(.medium)
                .foregroundStyle(.white)
        }
        .buttonStyle(.bordered)
    }
}

#Preview {
    NewChatButton()
        .environmentObject(AppState())
}
