//
//  ChatConfig.swift
//  NegoAI
//
//  Created by Michal Ukropec on 18/04/2025.
//

import SwiftUI

struct ChatConfig: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack {
            HStack {
                Spacer()
                if appState.currentChat != nil {
                    RemoveChatButton()
                }
            }
            .padding(.bottom, 8)

            VStack {
                HStack {
                    Text("Temperature")
                    Spacer()
                    AutoWidthTextField(value: $appState.temperatureAI)
                }
                Slider(
                    value: $appState.temperatureAI,
                    in: 0...2
                )
            }

            VStack {
                HStack {
                    Text("Max tokens")
                    Spacer()
                    AutoWidthTextField(value: $appState.maxTokensAI)
                }
                Slider(
                    value: $appState.maxTokensAI,
                    in: 600...16_000
                )
            }

            VStack {
                HStack {
                    Text("Top P")
                    Spacer()
                    AutoWidthTextField(value: $appState.topPAI)
                }
                Slider(
                    value: $appState.topPAI,
                    in: 0...1
                )
            }

            SystemMessageEditor()

            Button {
                withAnimation {
                    if appState.currentPage != 0 {
                        appState.previousPage = appState.currentPage
                        appState.currentPage = 0
                    } else {
                        appState.currentPage = 1
                    }
                }
            } label: {
                Text(
                    appState.currentPage != 0
                        ? "Open helper questions" : "Close helper questions"
                )
                .frame(maxWidth: .infinity)
                .padding(8)
            }
            .buttonStyle(.bordered)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

#Preview {
    ChatConfig()
        .environmentObject(AppState())
}
