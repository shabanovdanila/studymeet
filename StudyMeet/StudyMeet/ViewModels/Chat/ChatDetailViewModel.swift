//
//  ChatDetailViewModel.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 05.07.2025.
//

import Foundation

final class ChatDetailViewModel: ObservableObject {
    private let chatClient: ChatClient
    private let chatId: Int
    private let userSession: UserSession = .shared
    
    @Published var messages: [ChatMessage] = []
    @Published var messageText: String = ""
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    private var currentPage: Int = 1
    private let limit: Int = 30
    
    init(chatId: Int, chatClient: ChatClient = DependencyContainer.shared.makeChatClient()) {
        self.chatId = chatId
        self.chatClient = chatClient
        observeSocket()
    }
    
    func onAppear() {
        Task {
            await loadMessages()
            print("LOADING")
        }
    }
    
    @MainActor
    func loadMessages() async {
        guard !isLoading else { return }
        isLoading = true
        error = nil
        print("DEBUG after error")
        do {
            print("Start Loading messages")
            let chatMessage = try await chatClient.getInfoChatById(id: chatId, limit: "\(limit)", page: "\(currentPage)")
            print("After Getting messages")
            messages = chatMessage.messages
            print(99999)
            print(messages.count)
            print(21112221)
        } catch {
            print(error)
            self.error = error
        }
        
        isLoading = false
    }
    
    func sendMessage() {
        let trimmedText = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        
        let message = CreateMessageRequest(
            chat_id: chatId,
            answered_message_id: nil,
            content: trimmedText
        )
        
        ChatSocketService.shared.sendMessage(message)
        messageText = ""
    }
    
    private func observeSocket() {
        NotificationCenter.default.addObserver(
            forName: .newMessageReceived,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard
                let self,
                let message = notification.object as? ChatMessage,
                message.chat_id == self.chatId
            else {
                return
            }
            self.messages.append(message)
        }
    }
}
