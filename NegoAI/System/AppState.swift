//
//  AppState.swift
//  NegoAI
//
//  Created by Michal Ukropec on 18/04/2025.
//

import Foundation

enum ActiveContextField: Hashable {
    case q1, q2, q3, q4, q5, q6, q7, q8, q9, q10
}

struct ContextData {
    var q1: String = ""
    var q2: String = ""
    var q3: String = ""
    var q4: String = ""
    var q5: String = ""
    var q6: String = ""
    var q7: String = ""
    var q8: String = ""
    var q9: String = ""
    var q10: String = ""
}

struct Message: Codable, Hashable, Identifiable {
    var id = UUID() 
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
    // Context
    @Published var contextData: ContextData = ContextData()
    @Published var contextDataFocused: Bool = false
    //

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
    var currentMessages: [Message] {
        guard let currentChatID = currentChat,
            let chat = chatList.first(where: { $0.id == currentChatID })
        else {
            return []
        }
        return chat.messages
    }

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

    func formattedContextSummary() -> String {
        let context = contextData

        let fields: [(question: String, answer: String)] = [
            ("1. Who are you negotiating with?", context.q1),
            ("2. What is the subject of the deal?", context.q2),
            ("3. What is the true goal of this negotiation?", context.q3),
            (
                "4. What do you believe is valuable to the counterparty?",
                context.q4
            ),
            ("5. What are your BATNA and ZOPA?", context.q5),
            (
                "6. What are the known decision criteria of the buyer?",
                context.q6
            ),
            (
                "7. Where do you feel uncertainty or lack of information?",
                context.q7
            ),
            ("8. What differentiates you (if you are the seller)?", context.q8),
            ("9. What has been tried already?", context.q9),
            (
                "10. Do you want tactical advice or strategic guidance?",
                context.q10
            ),
        ]

        let nonEmptyPairs =
            fields
            .filter {
                !$0.answer.trimmingCharacters(in: .whitespacesAndNewlines)
                    .isEmpty
            }
            .map { "\($0.question) → \($0.answer)" }

        return nonEmptyPairs.joined(separator: "\n")
    }

    func formattedChatHistory() -> String {
        guard let currentChatID = currentChat,
            let chat = chatList.first(where: { $0.id == currentChatID })
        else {
            return "No chat selected."
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short

        let lines = chat.messages.map { message in
            let sender = message.isOwn ? "You" : "System"
            let timestamp = dateFormatter.string(from: message.date)
            return "[\(timestamp)] \(sender): \(message.text)"
        }

        return lines.joined(separator: "\n")
    }

    func sendToOpenAIAndAddResponse() {
        guard
            let url = URL(string: "https://api.openai.com/v1/chat/completions")
        else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(
            "Bearer ",
            forHTTPHeaderField: "Authorization")  // 🔐 Replace with your key
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let systemPrompt = """
            You are a world-class negotiation assistant. Use the provided context to help the user design a better strategy and offer insights.

            Context:
            \(formattedContextSummary())
            """

        var messages: [[String: String]] = [
            ["role": "system", "content": systemPrompt]
        ]

        if let currentChatID = currentChat,
            let chat = chatList.first(where: { $0.id == currentChatID })
        {
            for message in chat.messages {
                messages.append([
                    "role": message.isOwn ? "user" : "assistant",
                    "content": message.text,
                ])
            }
        }

        let body: [String: Any] = [
            "model": "gpt-4-1106-preview",
            "messages": messages,
            "temperature": Double(temperatureAI),
            "max_tokens": Int(maxTokensAI),
            "top_p": Double(topPAI),
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            print("Failed to encode request body: \(error)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("API error: \(error)")
                return
            }

            guard let data = data else {
                print("No data returned")
                return
            }

            do {
                if let result = try JSONSerialization.jsonObject(with: data)
                    as? [String: Any],
                    let choices = result["choices"] as? [[String: Any]],
                    let message = choices.first?["message"] as? [String: Any],
                    let reply = message["content"] as? String
                {

                    DispatchQueue.main.async {
                        self.addMessage(
                            text: reply.trimmingCharacters(
                                in: .whitespacesAndNewlines), isOwn: false)
                    }

                } else {
                    print(
                        "Malformed response from OpenAI:\n\(String(data: data, encoding: .utf8) ?? "")"
                    )
                }
            } catch {
                print("Failed to parse response: \(error)")
            }
        }.resume()
    }

}
