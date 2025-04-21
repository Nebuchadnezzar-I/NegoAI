//
//  NewThread.swift
//  NegoAI
//
//  Created by Michal Ukropec on 21/04/2025.
//

import SwiftUI

struct NewThread: View {
    @EnvironmentObject var appState: AppState
    @State private var isHovering = false

    var body: some View {
        Button {
            appState.addThread(title: "New Thread")
        } label: {
            Image(systemName: "plus")
                .foregroundColor(.white)
                .padding(10)
                .background(isHovering ? .gray.opacity(0.2) : .clear)
                .cornerRadius(8)
        }
        .onHover { hovering in
            isHovering = hovering
        }
    }
}
