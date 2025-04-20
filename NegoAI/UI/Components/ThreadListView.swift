//
//  ThreadListView.swift
//  NegoAI
//
//  Created by Michal Ukropec on 20/04/2025.
//

import SwiftUI

struct ThreadListView: View {
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Thred One")
                    .foregroundColor(.white)
                    .font(.headline)
                Spacer()
                Text("13:20")
                    .foregroundColor(.white.opacity(0.8))
            }
            Text("Last long message")
                .foregroundColor(.white.opacity(0.6))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12)
        .background(.blue)
        .cornerRadius(8)
    }
}

#Preview {
    ThreadListView()
}
