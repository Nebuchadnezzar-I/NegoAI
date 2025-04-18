//
//  MessageField.swift
//  NegoAI
//
//  Created by Michal Ukropec on 18/04/2025.
//

import SwiftUI

struct MessageField: View {
    @EnvironmentObject var appState: AppState
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)

                TextField("Search", text: $appState.messageText)
                    .focused($isFocused)
                    .textFieldStyle(PlainTextFieldStyle())
                    .onSubmit {
                        isFocused = false
                    }

                if !appState.messageText.isEmpty {
                    Button(action: { appState.messageText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .stroke(
                        appState.messageFocused
                            ? Color.accentColor : Color.gray.opacity(0.3),
                        lineWidth: 1)
            )
            .animation(
                .easeInOut(duration: 0.2), value: appState.messageFocused
            )
            .onChange(of: isFocused) {
                appState.messageFocused = isFocused
            }
            .onChange(of: appState.messageFocused) {
                isFocused = appState.messageFocused
            }
            .onAppear {
                isFocused = false
                appState.messageFocused = false
            }
        }
    }
}

#Preview {
    MessageField()
        .environmentObject(AppState())
}
