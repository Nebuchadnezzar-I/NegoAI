//
//  NegoAIApp.swift
//  NegoAI
//
//  Created by Michal Ukropec on 18/04/2025.
//

import SwiftUI

@main
struct NegoAIApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(
                    minWidth: 1400, maxWidth: 1800,
                    minHeight: 600, maxHeight: 900
                )
                .environmentObject(appState)
        }
        .windowResizability(.contentSize)
    }
}
