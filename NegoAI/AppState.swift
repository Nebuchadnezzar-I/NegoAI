//
//  AppState.swift
//  NegoAI
//
//  Created by Michal Ukropec on 20/04/2025.
//

import Foundation

struct AIMessage: Identifiable, Equatable {
    let id: UUID
    let threadID: UUID
    let content: String
    let timestamp: Date
}

struct Thread: Identifiable, Equatable {
    let id: UUID
    let title: String
}

class AppState: ObservableObject {
    static let shared = AppState()

    @Published var threads: [Thread] = []
    @Published var messages: [AIMessage] = []

    @Published var selectedThread: Thread? {
        didSet {
            updateCurrentMessages()
        }
    }

    @Published private(set) var currentMessages: [AIMessage] = []

    private func updateCurrentMessages() {
        guard let thread = selectedThread else {
            currentMessages = []
            return
        }
        currentMessages = messages.filter { $0.threadID == thread.id }
    }

    func addThread(title: String) -> Thread {
        let thread = Thread(id: UUID(), title: title)
        threads.append(thread)
        return thread
    }

    func addMessage(to thread: Thread, content: String) {
        let message = AIMessage(
            id: UUID(), threadID: thread.id, content: content, timestamp: .now)
        messages.append(message)
        if thread == selectedThread {
            currentMessages.append(message)
        }
    }
}
