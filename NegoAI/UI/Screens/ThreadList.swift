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
        VStack {
            ScrollView {
                ThreadListView()
                ThreadListView()
                ThreadListView()
                ThreadListView()
            }
        }
    }
}

#Preview {
    ThreadList()
}
