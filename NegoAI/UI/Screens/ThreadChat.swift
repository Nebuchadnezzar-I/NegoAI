//
//  ThreadChat.swift
//  NegoAI
//
//  Created by Michal Ukropec on 20/04/2025.
//

import MarkdownUI
import SwiftUI

struct ThreadChat: View {
    @EnvironmentObject var appState: AppState
    @State private var textHeight: CGFloat = 24

    var body: some View {
        DepthContainer {
            ZStack {
                GeometryReader { geo in
                    ScrollViewReader { scrollProxy in
                        ScrollView {
                            Rectangle()
                                .fill(Color.clear)
                                .frame(height: 8)

                            VStack {
                                ForEach(appState.currentMessages) { message in
                                    Message(
                                        message: message.content,
                                        geo: geo,
                                        sender: message.isSystem
                                            ? "system" : "user"
                                    )
                                }

                                Color.clear
                                    .frame(height: 93)
                                    .id("bottom")
                            }
                        }
                        .scrollIndicators(.hidden)
                        .frame(width: geo.size.width, height: geo.size.height)
                        .onChange(of: appState.currentMessages) {
                            withAnimation {
                                scrollProxy.scrollTo("bottom", anchor: .bottom)
                            }
                        }
                    }

                    input
                }
            }
        }
    }

    var input: some View {
        VStack {
            Spacer()

            ZStack(alignment: .topLeading) {
                if appState.messageInputText.isEmpty {
                    Text("Message AI")
                        .foregroundColor(.gray)
                        .font(.system(size: 18))
                        .foregroundColor(.gray)
                        .padding(.leading, 17)
                        .padding(.top, 20)
                        .zIndex(1)
                }

                DynamicTextEditor(
                    text: $appState.messageInputText,
                    dynamicHeight: $textHeight,
                    minHeight: 24,
                    maxHeight: 120,
                    font: .systemFont(ofSize: 18),
                    onSubmit: {
                        if !appState.messageInputText.isEmpty {
                            appState.addMessage(
                                to: appState.selectedThread!,
                                content: appState.messageInputText,
                                sender: "user")

                            appState.requestAIResponse()
                            appState.messageInputText = ""
                        }
                    }
                )
                .frame(height: textHeight)
                .padding(12)
                .background(.thinMaterial)
                .cornerRadius(12)
                .zIndex(0)

            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
    }
}

struct DynamicTextEditor: UIViewRepresentable {
    @Binding var text: String
    @Binding var dynamicHeight: CGFloat
    var minHeight: CGFloat = 24
    var maxHeight: CGFloat = 120
    var font: UIFont = UIFont.systemFont(ofSize: 18)
    var onSubmit: (() -> Void)? = nil

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.font = font
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.delegate = context.coordinator
        textView.setContentCompressionResistancePriority(
            .defaultLow, for: .horizontal)
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }

        DispatchQueue.main.async {
            let size = uiView.sizeThatFits(
                CGSize(width: uiView.frame.width, height: .infinity))
            dynamicHeight = min(max(size.height, minHeight), maxHeight)
            uiView.isScrollEnabled = size.height > maxHeight
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: DynamicTextEditor

        init(_ parent: DynamicTextEditor) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }

        func textView(
            _ textView: UITextView,
            shouldChangeTextIn range: NSRange,
            replacementText text: String
        ) -> Bool {
            if text == "\n" {
                parent.onSubmit?()
                return false
            }
            return true
        }
    }
}

#Preview {
    ThreadChat()
        .environmentObject(AppState())
}
