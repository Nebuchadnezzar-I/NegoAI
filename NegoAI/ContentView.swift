//
//  ContentView.swift
//  NegoAI
//
//  Created by Michal Ukropec on 18/04/2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {

        #if targetEnvironment(macCatalyst)
            VStack {
                GeometryReader { geo in
                    HStack(spacing: 0) {
                        ChatList()
                            .frame(width: geo.size.width * 0.25)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                appState.chatFilterFocused = false
                                appState.chatSystemFocused = false
                            }

                        LineSpacer()

                        Chat()
                            .frame(width: geo.size.width * 0.5)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                appState.chatFilterFocused = false
                                appState.chatSystemFocused = false
                            }

                        LineSpacer()

                        ChatConfig()
                            .frame(width: geo.size.width * 0.25)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                appState.chatFilterFocused = false
                                appState.chatSystemFocused = false
                            }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        #else
            TabView {
                ChatList()
                    .background(.red)

                Chat()
                    .background(.green)

                ChatConfig()
                    .background(.blue)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .ignoresSafeArea()
        #endif
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
