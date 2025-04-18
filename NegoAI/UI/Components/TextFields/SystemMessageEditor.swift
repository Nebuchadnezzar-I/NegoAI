//
//  SystemMessageEditor.swift
//  NegoAI
//
//  Created by Michal Ukropec on 18/04/2025.
//

import SwiftUI

struct SystemMessageEditor: View {
    @EnvironmentObject var appState: AppState
    @FocusState private var isFocused: Bool

    var body: some View {
        ZStack(alignment: .topLeading) {
            if appState.chatSystemText.isEmpty {
                Text(
                    "Describe desired model behavior (tone, tool usage, response style)"
                )
                .font(.body)
                .foregroundColor(.gray)
                .padding(.top, 16)
                .padding(.leading, 13)
                .padding(.bottom, 16)
                .padding(.trailing, 13)
            }

            TextEditor(text: $appState.chatSystemText)
                .font(.body)
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .stroke(
                            appState.chatSystemFocused
                                ? Color.accentColor : Color.gray.opacity(0.3),
                            lineWidth: 1)
                )
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .contentShape(Rectangle())
                .animation(
                    .easeInOut(duration: 0.2), value: appState.chatSystemFocused
                )
                .focused($isFocused)
                .onSubmit {
                    isFocused = false
                }
                .onChange(of: isFocused) {
                    appState.chatSystemFocused = isFocused
                }
                .onChange(of: appState.chatSystemFocused) {
                    isFocused = appState.chatSystemFocused
                }
                .onAppear {
                    isFocused = false
                    appState.chatSystemFocused = false
                }
        }
    }
}

#Preview {
    SystemMessageEditor()
        .environmentObject(AppState())
        .padding()
}
