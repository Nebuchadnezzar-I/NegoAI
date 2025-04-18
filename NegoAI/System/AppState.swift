//
//  AppState.swift
//  NegoAI
//
//  Created by Michal Ukropec on 18/04/2025.
//

import Foundation

struct Message: Codable, Hashable {
    var text: String
    var date: Date
    var isOwn: Bool
}

struct ChatObject: Codable, Identifiable {
    var id = UUID()
    var name: String
    var date: Date
    var messages: [Message]
    var createdAt: Date
}

class AppState: ObservableObject {
    // Layout
    @Published var currentPage: Int = 1
    @Published var previousPage: Int = 1
    //

    // AI model controls
    @Published var temperatureAI: Float16 = 1.00
    @Published var maxTokensAI: Float16 = 900.00
    @Published var topPAI: Float16 = 1.00
    //

    // Chat list
    @Published var chatFilterText: String = ""
    @Published var chatFilterFocused: Bool = false

    @Published var chatSystemText: String = ""
    @Published var chatSystemFocused: Bool = false

    @Published var messageText: String = ""
    @Published var messageFocused: Bool = false
    //

    // Chat
    var currentMessages: [Message] = [
        Message(text: "Hello, world!", date: Date(), isOwn: false),
        Message(text: "How are you?", date: Date(), isOwn: true),
    ]
//    var currentMessages: [Message] {
//        guard let currentChatID = currentChat,
//            let chat = chatList.first(where: { $0.id == currentChatID })
//        else {
//            return []
//        }
//        return chat.messages
//    }

    @Published var currentChat: UUID? {
        didSet {
            if let id = currentChat {
                UserDefaults.standard.set(id.uuidString, forKey: "currentChat")
            } else {
                UserDefaults.standard.removeObject(forKey: "currentChat")
            }
        }
    }

    @Published var chatList: [ChatObject] {
        didSet {
            saveThreads()
        }
    }

    init() {
        if let idString = UserDefaults.standard.string(forKey: "currentChat"),
            let id = UUID(uuidString: idString)
        {
            self.currentChat = id
        } else {
            self.currentChat = nil
        }

        self.chatList = AppState.loadThreads()
    }

    private func saveThreads() {
        if let data = try? JSONEncoder().encode(chatList) {
            UserDefaults.standard.set(data, forKey: "threads")
        }
    }

    private static func loadThreads() -> [ChatObject] {
        if let data = UserDefaults.standard.data(forKey: "threads"),
            let chats = try? JSONDecoder().decode([ChatObject].self, from: data)
        {
            return chats
        }
        return []
    }
    //
}

// Methods
extension AppState {
    func addNewChat(name: String = "New Chat") {
        let newChat = ChatObject(
            name: name,
            date: Date(),
            messages: [],
            createdAt: Date()
        )

        chatList.insert(newChat, at: 0)
        self.currentChat = newChat.id
    }

    func removeChat() {
        let id = currentChat
        chatList.removeAll { $0.id == id }

        if currentChat == id {
            currentChat = chatList.first?.id
        }
    }

    func addMessage(text: String, isOwn: Bool = true) {
        guard let currentChatID = currentChat,
            let index = chatList.firstIndex(where: { $0.id == currentChatID })
        else {
            return
        }

        let newMessage = Message(
            text: text,
            date: Date(),
            isOwn: isOwn
        )

        chatList[index].messages.append(newMessage)
    }
}
