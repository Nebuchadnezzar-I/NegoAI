//
//  ThreadListView.swift
//  NegoAI
//
//  Created by Michal Ukropec on 20/04/2025.
//

import SwiftUI

struct ThreadListView: View {
    @EnvironmentObject var appState: AppState
    let thread: Thread

    var isSelected: Bool {
        appState.selectedThread?.id == thread.id
    }

    func formattedTime(from date: Date?) -> String {
        guard let date = date else {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: thread.timestamp)
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(thread.title)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .semibold))
                Spacer()
                Text(
                    formattedTime(
                        from: appState.lastMessage(for: thread)?.timestamp)
                )
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(
                    isSelected ? .white : .white.opacity(0.6))
            }

            Text(appState.lastMessage(for: thread)?.content ?? "No messages")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(
                    isSelected ? .white.opacity(0.8) : .white.opacity(0.6)
                )
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(1)
        }
        .padding(12)
        .background(
            (isSelected ? Color.blue : Color.clear)
                .animation(.easeInOut(duration: 0.1), value: isSelected)
        )
        .cornerRadius(8)
        .contentShape(Rectangle())
        .onTapGesture {
            appState.selectedThread = thread
        }
        .onTapGesture(count: 2) {
            appState.deleteSelectedThread()
        }
    }
}

#Preview {
    ThreadList()
        .environmentObject(AppState())
}
