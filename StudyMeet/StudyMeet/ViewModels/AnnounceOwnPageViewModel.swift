//
//  AnnounceOwnPageViewModel.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 08.06.2025.
//

import Foundation

final class AnnounceOwnPageViewModel: ObservableObject {
    private let clientAnnouncement: AnnounceClient
    private let userClient: UserClient
    private let responseClient: ResponseClient
    
    private let userSession: UserSession = .shared
    
    @Published var user: User?
    @Published var announcement: Announcement? = nil
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var tags: [String] = []
    @Published var newTag: String = ""
    @Published var responses: [Response] = []
    
    @Published var error: Error?
    @Published var isRefreshing: Bool = false
    @Published var isLoading: Bool = false
    @Published var isEditing: Bool = false
    @Published var alertMessage: String = ""
    @Published var updateSuccess: Bool = false
    @Published var showAlert: Bool = false
    
    init(clientAnnouncement: AnnounceClient = DependencyContainer.shared.makeAnnounceClient(),
         userClient: UserClient = DependencyContainer.shared.makeUserClient(), responseClient: ResponseClient = DependencyContainer.shared.makeResponseClient()) {
        self.clientAnnouncement = clientAnnouncement
        self.userClient = userClient
        self.responseClient = responseClient
    }
    
    @MainActor
    func loadAnnouncementProfile(announcementId: Int) async {
        guard let userId = userSession.currentUser?.id else { return }
        guard !isLoading else { return }
        
        isLoading = true
        error = nil

        do {
            async let userTask = userClient.getUserById(id: userId)
            async let announcementTask = clientAnnouncement.getFullAnnouncementById(id: announcementId)
            async let responseTask = responseClient.getResponseByAnnounceId(announce_id: announcementId)
            
            let (loadedUser, loadedAnnouncement, loadResponses) = await (try userTask, try announcementTask, try responseTask)
            
            self.user = loadedUser
            self.announcement = loadedAnnouncement
            self.title = loadedAnnouncement.title
            self.description = loadedAnnouncement.description ?? ""
            self.tags = loadedAnnouncement.tags.map { $0.name ?? "" }
            self.responses = loadResponses
            
        } catch {
            self.error = error
            showAlert(message: "Ошибка при загрузке данных: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    @MainActor
    func updateAnnouncement(announcementId: Int) async {
        guard !isLoading else { return }
        
        isLoading = true
        error = nil
        
        do {
            try await clientAnnouncement.updateAnnouncementById(
                id: announcementId,
                title: title,
                description: description,
                tags: tags
            )
            
            updateSuccess = true
            showAlert(message: "Объявление успешно обновлено")
            
        } catch {
            self.error = error
            showAlert(message: "Ошибка при обновлении: \(error.localizedDescription)")
            updateSuccess = false
        }
        
        isLoading = false
    }
    
    @MainActor
    func refresh(announcementId: Int) async {
        guard !isRefreshing else { return }
        
        isRefreshing = true
        error = nil
        
        // Сохраняем текущие редактируемые данные, если находимся в режиме редактирования
        let currentTitle = title
        let currentDescription = description
        let currentTags = tags
        let wasEditing = isEditing
        
        do {
            // Загружаем свежие данные
            async let userTask = userClient.getUserById(id: userSession.currentUser?.id ?? 0)
            async let announcementTask = clientAnnouncement.getFullAnnouncementById(id: announcementId)
            
            let (loadedUser, loadedAnnouncement) = await (try userTask, try announcementTask)
            
            self.user = loadedUser
            self.announcement = loadedAnnouncement
            
            // Восстанавливаем редактируемые данные, если были в режиме редактирования
            if wasEditing {
                self.title = currentTitle
                self.description = currentDescription
                self.tags = currentTags
            } else {
                self.title = loadedAnnouncement.title
                self.description = loadedAnnouncement.description ?? ""
                self.tags = loadedAnnouncement.tags.map { $0.name ?? "" }
            }
            
        } catch {
            self.error = error
            showAlert(message: "Ошибка при обновлении данных: \(error.localizedDescription)")
        }
        
        isRefreshing = false
    }
    
    
    func addTag() {
        let trimmedTag = newTag.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedTag.isEmpty, !tags.contains(trimmedTag) {
            tags.append(trimmedTag)
            newTag = ""
        }
    }
    
    func removeTag(_ tag: String) {
        tags.removeAll { $0 == tag }
    }
    
    
    private func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
}
