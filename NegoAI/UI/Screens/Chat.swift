//
//  Chat.swift
//  NegoAI
//
//  Created by Michal Ukropec on 18/04/2025.
//

import SwiftUI

struct Chat: View {
    @EnvironmentObject var appState: AppState
    @FocusState private var activeField: ActiveContextField?

    var body: some View {
        VStack {
            GeometryReader { geo in
                HStack(spacing: 0) {
                    SSContext(activeField: $activeField)
                        .frame(width: geo.size.width, height: geo.size.height)

                    SSChat()
                        .frame(width: geo.size.width, height: geo.size.height)
                }
                .offset(x: -CGFloat(appState.currentPage) * geo.size.width)
                .animation(.easeInOut, value: appState.currentPage)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .clipped()
    }
}

#Preview {
    Chat()
        .environmentObject(AppState())
}
