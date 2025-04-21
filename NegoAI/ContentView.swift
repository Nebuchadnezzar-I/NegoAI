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
        GeometryReader { geo in
            HStack(spacing: 0) {
                ThreadList()
                    .padding(.vertical, 16)
                    .padding(.leading, 16)
                    .frame(width: geo.size.width * 0.25)
                    .contentShape(Rectangle())

                ThreadChat()
                    .padding(.horizontal, 16)
                    .frame(
                        width: appState.isRightSideVisible
                            ? geo.size.width * 0.5
                            : geo.size.width * 0.75 - 100,
                        height: geo.size.height - 32
                    )
                    .contentShape(Rectangle())

                ThreadProps()
                    .padding(.vertical, 16)
                    .padding(.trailing, 16)
                    .frame(
                        width: appState.isRightSideVisible
                            ? geo.size.width * 0.25
                            : 100
                    )
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            appState.isRightSideVisible.toggle()
                        }
                    }
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(Color.gray.opacity(0.1))
        }
    }
}

#Preview {
    ContentView()
}
