//
//  ChatListViewModel.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 04.07.2025.
//
import Foundation

final class ChatListViewModel: ObservableObject {
    private let chatClient: ChatClient
    private let userSession: UserSession = .shared
    
    @Published var chats: [Chat] = []
    @Published var error: Error?
    @Published var isLoading: Bool = false
    
    private var currentPage: Int = 1
    private let limit: Int = 20
    private var hasMorePages: Bool = true
    
    init(chatClient: ChatClient = DependencyContainer.shared.makeChatClient()) {
        self.chatClient = chatClient
    }
    
    @MainActor
    func refreshChats() async {
        currentPage = 1
        chats = []
        hasMorePages = true
        await loadChats()
    }
    
    @MainActor
    func loadChats() async {
        guard !isLoading && hasMorePages else { return }
        isLoading = true
        error = nil
        
        do {
            let response = try await chatClient.getAllUserChats(limit: "\(limit)", page: "\(currentPage)")
            let newChats = response.filter { newChat in
                !chats.contains(where: { $0.id == newChat.id })
            }
            chats.append(contentsOf: newChats)
            hasMorePages = response.count >= limit
        } catch {
            self.error = error
            print(error)
        }
        
        isLoading = false
    }
    
    func loadNextPage() {
        guard !isLoading && hasMorePages else { return }
        currentPage += 1
        Task {
            await loadChats()
        }
    }
}

