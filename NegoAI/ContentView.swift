//
//  ContentView.swift
//  NegoAI
//
//  Created by Michal Ukropec on 18/04/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 0) {
                ThreadList()
                    .contentShape(Rectangle())
                    .padding(.vertical, 16)
                    .padding(.leading, 16)
                    .frame(width: geo.size.width * 0.25)

                ThreadChat()
                    .contentShape(Rectangle())
                    .padding(.horizontal, 16)
                    .frame(
                        width: geo.size.width * 0.5,
                        height: geo.size.height - 32)

                ThreadProps()
                    .contentShape(Rectangle())
                    .padding(.vertical, 16)
                    .padding(.trailing, 16)
                    .frame(width: geo.size.width * 0.25)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(Color.gray.opacity(0.1))
        }
    }
}

#Preview {
    ContentView()
}
