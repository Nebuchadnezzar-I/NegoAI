//
//  ChatFilter.swift
//  NegoAI
//
//  Created by Michal Ukropec on 18/04/2025.
//

import SwiftUI

struct ChatFilter: View {
    @EnvironmentObject var appState: AppState
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)

                TextField("Search", text: $appState.chatFilterText)
                    .focused($isFocused)
                    .textFieldStyle(PlainTextFieldStyle())
                    .onSubmit {
                        isFocused = false
                    }

                if !appState.chatFilterText.isEmpty {
                    Button(action: { appState.chatFilterText = "" }) {
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
                        appState.chatFilterFocused
                            ? Color.accentColor : Color.gray.opacity(0.3),
                        lineWidth: 1)
            )
            .animation(
                .easeInOut(duration: 0.2), value: appState.chatFilterFocused
            )
            .onChange(of: isFocused) {
                appState.chatFilterFocused = isFocused
            }
            .onChange(of: appState.chatFilterFocused) {
                isFocused = appState.chatFilterFocused
            }
            .onAppear {
                isFocused = false
                appState.chatFilterFocused = false
            }
        }
    }
}

#Preview {
    ChatFilter()
        .environmentObject(AppState())
}
