//
//  AppState.swift
//  NegoAI
//
//  Created by Michal Ukropec on 20/04/2025.
//

import Foundation

struct AIMessage: Identifiable, Codable, Equatable {
    let id: UUID
    let threadID: UUID
    let content: String
    let timestamp: Date
    let isSystem: Bool
}

struct Thread: Identifiable, Codable, Equatable {
    let id: UUID
    let title: String
    let timestamp: Date
}

class AppState: ObservableObject {
    static let shared = AppState()

    @Published var messageInputText: String = ""
    @Published var isRightSideVisible: Bool = false

    @Published private(set) var currentMessages: [AIMessage] = []

    @Published var threads: [Thread] = [] {
        didSet { saveData(threads, forKey: threadsKey) }
    }

    @Published var messages: [AIMessage] = [] {
        didSet { saveData(messages, forKey: messagesKey) }
    }

    @Published var selectedThread: Thread? {
        didSet {
            updateCurrentMessages()
        }
    }

    private let messagesKey = "messages"
    private let threadsKey = "threads"

    private func saveData<T: Encodable>(_ data: T, forKey key: String) {
        if let encoded = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }

    private func loadData<T: Decodable>(forKey key: String, as type: T.Type)
        -> T?
    {
        guard let savedData = UserDefaults.standard.data(forKey: key),
            let decoded = try? JSONDecoder().decode(T.self, from: savedData)
        else {
            return nil
        }
        return decoded
    }

    init() {
        if let savedThreads = loadData(forKey: threadsKey, as: [Thread].self) {
            self.threads = savedThreads
            self.selectedThread = savedThreads[0]
        }

        if let savedMessages = loadData(
            forKey: messagesKey, as: [AIMessage].self)
        {
            self.messages = savedMessages
        }

        updateCurrentMessages()
    }
}

extension AppState {
    private func updateCurrentMessages() {
        guard let thread = selectedThread else {
            currentMessages = []
            return
        }
        currentMessages = messages.filter { $0.threadID == thread.id }
    }

    func addThread(title: String) {
        let thread = Thread(id: UUID(), title: title, timestamp: .now)
        threads.insert(thread, at: 0)
        selectedThread = thread
    }

    func addMessage(to thread: Thread, content: String, sender: String) {
        let message = AIMessage(
            id: UUID(), threadID: thread.id, content: content, timestamp: .now,
            isSystem: sender == "system" ? true : false)
        messages.append(message)
        if thread == selectedThread {
            currentMessages.append(message)
        }
    }

    func lastMessage(for thread: Thread) -> AIMessage? {
        messages
            .filter { $0.threadID == thread.id }
            .sorted(by: { $0.timestamp < $1.timestamp })
            .last
    }

    func deleteSelectedThread() {
        guard let thread = selectedThread else { return }
        messages.removeAll { $0.threadID == thread.id }
        threads.removeAll { $0.id == thread.id }
        selectedThread = threads.first
        updateCurrentMessages()
    }

    func requestAIResponse() {
        guard let thread = selectedThread else { return }

        let apiKey =
            ""

        let url = URL(string: "https://api.openai.com/v1/responses")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(
            "Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        var input: [[String: Any]] = []

        input.append([
            "role": "system",
            "content": [
                [
                    "type": "input_text",
                    "text": """
                    You are a negotiation coach inspired by the book "3D Negotiation". Your job is to help the user:
                    - Clarify what they want (value)
                    - Think in 3D: setup, deal design, and tactics
                    - Identify hidden interests of all parties
                    - Suggest powerful questions to uncover information
                    - Offer smart ways to reframe and package deals
                    - Warn about traps, weak framing, or poor preparation

                    Be conversational, but analytical. Ask questions back to get clarity. Push for realism and creativity. When possible, offer examples or reframe ideas into stronger versions.

                    Act as a sharp, experienced negotiation strategist.
                    """,
                ]
            ],
        ])

        let threadMessages =
            messages
            .filter { $0.threadID == thread.id }
            .sorted(by: { $0.timestamp < $1.timestamp })

        for msg in threadMessages {
            input.append([
                "role": msg.isSystem ? "system" : "user",
                "content": [
                    [
                        "type": "input_text",
                        "text": msg.content,
                    ]
                ],
            ])
        }

        input.append([
            "role": "user",
            "content": [
                [
                    "type": "input_text",
                    "text": messageInputText,
                ]
            ],
        ])

        let payload: [String: Any] = [
            "model": "gpt-4.1-mini",
            "input": input,
            "text": ["format": ["type": "text"]],
            "reasoning": [:],
            "tools": [],
            "temperature": 1,
            "max_output_tokens": 2048,
            "top_p": 1,
            "store": true,
        ]

        do {
            request.httpBody = try JSONSerialization.data(
                withJSONObject: payload)
        } catch {
            print("Failed to encode payload:", error)
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("OpenAI API error:", error)
                return
            }

            guard let data = data else {
                print("No data received.")
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data)
                    as? [String: Any],
                    let output = json["output"] as? [[String: Any]],
                    let contentArray = output.first?["content"]
                        as? [[String: Any]],
                    let text = contentArray.first?["text"] as? String
                {
                    DispatchQueue.main.async {
                        self.addMessage(
                            to: thread, content: text, sender: "system")
                    }
                } else {
                    print(
                        "Invalid or unexpected response:",
                        String(data: data, encoding: .utf8) ?? "nil")
                }
            } catch {
                print("Failed to decode JSON:", error)
            }
        }.resume()
    }
}
