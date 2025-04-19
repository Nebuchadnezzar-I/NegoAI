//
//  SSContext.swift
//  NegoAI
//
//  Created by Michal Ukropec on 18/04/2025.
//

import SwiftUI

struct SSContext: View {
    @EnvironmentObject var appState: AppState
    @FocusState.Binding var activeField: ActiveContextField?

    var body: some View {
        VStack {
            ScrollView {
                ContextFormField(
                    title: "1. Who are you negotiating with?",
                    text: $appState.contextData.q1,
                    fieldID: .q1,
                    activeField: $activeField
                )

                ContextFormField(
                    title: "2. What is the subject of the deal?",
                    text: $appState.contextData.q2,
                    fieldID: .q2,
                    activeField: $activeField
                )

                ContextFormField(
                    title: "3. What is the true goal of this negotiation?",
                    text: $appState.contextData.q3,
                    fieldID: .q3,
                    activeField: $activeField
                )

                ContextFormField(
                    title:
                        "4. What do you believe is valuable to the counterparty?",
                    text: $appState.contextData.q4,
                    fieldID: .q4,
                    activeField: $activeField
                )

                ContextFormField(
                    title:
                        "5. What are your BATNA and ZOPA? (best alternative and zone of possible agreement)",
                    text: $appState.contextData.q5,
                    fieldID: .q5,
                    activeField: $activeField
                )

                ContextFormField(
                    title:
                        "6. What are the known decision criteria of the buyer?",
                    text: $appState.contextData.q6,
                    fieldID: .q6,
                    activeField: $activeField
                )

                ContextFormField(
                    title:
                        "7. Where do you feel uncertainty or lack of information?",
                    text: $appState.contextData.q7,
                    fieldID: .q7,
                    activeField: $activeField
                )

                ContextFormField(
                    title:
                        "8. What differentiates you (if you are the seller)?",
                    text: $appState.contextData.q8,
                    fieldID: .q8,
                    activeField: $activeField
                )

                ContextFormField(
                    title:
                        "9. What has been tried already?",
                    text: $appState.contextData.q9,
                    fieldID: .q9,
                    activeField: $activeField
                )

                ContextFormField(
                    title:
                        "10. Do you want tactical advice or strategic guidance?",
                    text: $appState.contextData.q10,
                    fieldID: .q10,
                    activeField: $activeField
                )
            }
            .scrollIndicators(.hidden)
            .padding(20)
        }
    }
}

#Preview {
    Chat()
        .environmentObject(AppState())
}
