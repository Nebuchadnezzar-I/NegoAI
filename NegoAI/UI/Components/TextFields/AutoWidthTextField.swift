//
//  AutoWidthTextField.swift
//  NegoAI
//
//  Created by Michal Ukropec on 18/04/2025.
//

import SwiftUI

struct AutoWidthTextField: View {
    @Binding var value: Float16
    @State private var textWidth: CGFloat = 0

    var formatted: String {
        String(format: "%.2f", Float(value))
    }

    var body: some View {
        TextField(
            "",
            text: Binding(
                get: { formatted },
                set: {
                    if let v = Float16($0), v >= 0, v <= 2 {
                        value = v
                    }
                }
            )
        )
        .textFieldStyle(.roundedBorder)
        .multilineTextAlignment(.trailing)
        .frame(width: textWidth + 12)
        .background(
            Text(formatted)
                .font(.body)
                .background(
                    GeometryReader { geo in
                        Color.clear
                            .onAppear {
                                textWidth = geo.size.width
                            }
                    }
                )
                .hidden()
        )
        .onAppear {
            textWidth = measureWidth(for: formatted)
        }
        .onChange(of: formatted) {
            textWidth = measureWidth(for: formatted)
        }
    }

    private func measureWidth(for string: String) -> CGFloat {
        let font = UIFont.preferredFont(forTextStyle: .body)
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let size = (string as NSString).size(withAttributes: attributes)
        return size.width
    }
}

#Preview {
    ChatConfig()
        .environmentObject(AppState())
}
