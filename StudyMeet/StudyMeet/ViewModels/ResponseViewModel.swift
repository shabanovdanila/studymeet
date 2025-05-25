//
//  ResponseViewModel.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 20.05.2025.
//

import Foundation

final class ResponseViewModel: ObservableObject {
    private let responseClient: ResponseClient
    private let userSession: UserSession = .shared
    
    @Published var responses: [Response] = []
    @Published var userResponses: [Response] = []
    @Published var responseDescription: String = ""
    @Published var isLoading: Bool = false
    @Published var error: Error?
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    private var currentPage: Int = 1
    private var userResponsesPage: Int = 1
    private let limit: Int = 10
    private var hasMorePages: Bool = true
    private var hasMoreUserResponsesPages: Bool = true
    
    init(responseClient: ResponseClient = DependencyContainer.shared.makeResponseClient()) {
        self.responseClient = responseClient
    }
    
    // MARK: - Creating Responses
    
    @MainActor
    func createResponse(for announcementId: Int) async {
        guard !responseDescription.isEmpty else {
            showAlert(message: "Описание отклика не может быть пустым")
            return
        }
        
        isLoading = true
        error = nil
        
        do {
            try await responseClient.createResponse(
                description: responseDescription,
                announcement_id: announcementId
            )
            
            showAlert(message: "Отклик успешно отправлен!")
            responseDescription = ""
            
            await refreshResponses(for: announcementId)
            
        } catch {
            self.error = error
            showAlert(message: "Ошибка при отправке отклика: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    // MARK: - Loading Responses
    
    @MainActor
    func refreshResponses(for announcementId: Int) async {
        currentPage = 1
        responses = []
        hasMorePages = true
        await loadResponses(for: announcementId)
    }
    
    @MainActor
    func loadResponses(for announcementId: Int) async {
        guard !isLoading && hasMorePages else { return }
        
        isLoading = true
        error = nil
        
        do {
            let newResponses = try await responseClient.getResponseByAnnounceId(announce_id: announcementId)
            

            let uniqueResponses = newResponses.filter { newResponse in
                !responses.contains(where: { $0.id == newResponse.id })
            }
            
            responses.append(contentsOf: uniqueResponses)
            hasMorePages = newResponses.count >= limit
            
        } catch {
            self.error = error
            showAlert(message: "Ошибка при загрузке откликов: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    func loadNextPage(for announcementId: Int) {
        guard hasMorePages else { return }
        currentPage += 1
        Task {
            await loadResponses(for: announcementId)
        }
    }
    
    // MARK: - Loading User's Responses (responses to user's announcements)
    
    @MainActor
    func refreshUserResponses() async {
        guard let userId = userSession.currentUser?.id else { return }
        
        userResponsesPage = 1
        userResponses = []
        hasMoreUserResponsesPages = true
        await loadUserResponses()
    }
    
    @MainActor
    func loadUserResponses() async {
        guard let userId = userSession.currentUser?.id else { return }
        guard !isLoading && hasMoreUserResponsesPages else { return }
        
        isLoading = true
        error = nil
        
        do {
            let newResponses = try await responseClient.getResponseByUserId(user_id: userId)
            
            // Filter out duplicates
            let uniqueResponses = newResponses.filter { newResponse in
                !userResponses.contains(where: { $0.id == newResponse.id })
            }
            
            userResponses.append(contentsOf: uniqueResponses)
            hasMoreUserResponsesPages = newResponses.count >= limit
            
        } catch {
            self.error = error
            showAlert(message: "Ошибка при загрузке ваших откликов: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    func loadNextUserResponsesPage() {
        guard hasMoreUserResponsesPages else { return }
        userResponsesPage += 1
        Task {
            await loadUserResponses()
        }
    }
    
    // MARK: - Deleting Responses
    
    @MainActor
    func deleteResponse(responseId: Int) async {
        isLoading = true
        error = nil
        
        do {
            try await responseClient.deleteResponseById(response_id: responseId)
            
            // Remove from both arrays if present
            responses.removeAll { $0.id == responseId }
            userResponses.removeAll { $0.id == responseId }
            
            showAlert(message: "Отклик успешно удален")
            
        } catch {
            self.error = error
            showAlert(message: "Ошибка при удалении отклика: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    // MARK: - Helper Methods
    
    private func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
}
