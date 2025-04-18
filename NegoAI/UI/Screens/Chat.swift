//
//  Chat.swift
//  NegoAI
//
//  Created by Michal Ukropec on 18/04/2025.
//

import SwiftUI

struct Chat: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack {
            GeometryReader { geo in
                HStack(spacing: 0) {
                    SSContext()
                        .frame(width: geo.size.width, height: geo.size.height)
                        .background(.red)

                    SSChat()
                        .frame(width: geo.size.width, height: geo.size.height)
                        .background(.blue)
                }
                .offset(x: -CGFloat(appState.currentPage) * geo.size.width)
                .animation(.easeInOut, value: appState.currentPage)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .edgesIgnoringSafeArea(.all)
        }
        .clipped()
    }
}

#Preview {
    Chat()
        .environmentObject(AppState())
}
