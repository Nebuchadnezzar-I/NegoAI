//
//  ThreadList.swift
//  NegoAI
//
//  Created by Michal Ukropec on 20/04/2025.
//

import SwiftUI

struct ThreadList: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Spacer()
                NewThread()
            }

            ScrollView {
                ForEach(appState.threads) { thread in
                    ThreadListView(thread: thread)
                }
            }
            .scrollIndicators(.hidden)
            .cornerRadius(8)
        }
    }
}

#Preview {
    ThreadList()
        .environmentObject(AppState())
}
