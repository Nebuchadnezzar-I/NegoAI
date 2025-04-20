//
//  DepthContainer.swift
//  NegoAI
//
//  Created by Michal Ukropec on 20/04/2025.
//

import SwiftUI

struct DepthContainer<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                ZStack {
                    Color.gray.opacity(0.1)

                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(Color.black.opacity(0.1), lineWidth: 4)
                        .blur(radius: 4)
                        .offset(x: 0, y: 0)
                        .clipped()
                }
            )
            .background(Color.gray.opacity(0.1))
            .cornerRadius(16)
    }
}
