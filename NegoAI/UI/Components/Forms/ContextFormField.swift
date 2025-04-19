//
//  ContextFormField.swift
//  NegoAI
//
//  Created by Michal Ukropec on 19/04/2025.
//

import SwiftUI

struct ContextFormField: View {
    let title: String
    @Binding var text: String
    let fieldID: ActiveContextField
    @FocusState.Binding var activeField: ActiveContextField?
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)

            TextEditor(text: $text)
                .font(.body)
                .padding(8)
                .frame(minHeight: 150)
                .background(
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .stroke(
                            activeField == fieldID
                                ? Color.accentColor : Color.gray.opacity(0.3),
                            lineWidth: 1
                        )
                )
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .focused($activeField, equals: fieldID)
                .onTapGesture {
                    activeField = fieldID
                }
        }
        .padding()
        .contentShape(Rectangle())
        .onTapGesture {
            activeField = nil
        }
        .onSubmit {
            activeField = nil
        }
        .onChange(of: activeField) {
            appState.contextDataFocused = true
        }
        .onChange(of: appState.contextDataFocused) {
            activeField = nil
        }
        .onAppear {
            activeField = nil
            appState.contextDataFocused = false
        }
        .animation(.easeInOut(duration: 0.2), value: activeField)
    }
}
