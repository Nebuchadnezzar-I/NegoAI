//
//  SSContext.swift
//  NegoAI
//
//  Created by Michal Ukropec on 18/04/2025.
//

import SwiftUI

struct SSContext: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Text("Context")
    }
}

#Preview {
    SSContext()
        .environmentObject(AppState())
}
