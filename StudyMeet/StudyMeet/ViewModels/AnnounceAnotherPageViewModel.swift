//
//  AnnounceAnotherPageViewModel.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 11.06.2025.
//

import Foundation

final class AnnounceAnotherPageViewModel: ObservableObject {
    
    // MARK: - Dependencies
    private let clientAnnouncement: AnnounceClient
    private let userClient: UserClient
    private let responseClient: ResponseClient
    private let favoriteClient: FavoriteClient
    
    // MARK: - Published Properties
    @Published var user: User?
    @Published var announcement: Announcement?
    
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var tags: [String] = []
    
    @Published var isLoading: Bool = false
    @Published var isRefreshing: Bool = false
    @Published var isSubmittingResponse: Bool = false
    @Published var isReporting: Bool = false
    
    @Published var error: Error?
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false

    // MARK: - Init
    init(
        clientAnnouncement: AnnounceClient = DependencyContainer.shared.makeAnnounceClient(),
        userClient: UserClient = DependencyContainer.shared.makeUserClient(),
        responseClient: ResponseClient = DependencyContainer.shared.makeResponseClient(),
        favoriteClient: FavoriteClient = DependencyContainer.shared.makeFavoriteClient()
    ) {
        self.clientAnnouncement = clientAnnouncement
        self.userClient = userClient
        self.responseClient = responseClient
        self.favoriteClient = favoriteClient
    }

    // MARK: - Load & Refresh
    @MainActor
    func loadAnnouncementProfile(announcementId: Int, userId: Int) async {
        guard !isLoading else { return }
        isLoading = true
        error = nil

        do {
            async let userTask = userClient.getUserById(id: userId)
            async let announcementTask = clientAnnouncement.getFullAnnouncementById(id: announcementId)

            let (loadedUser, loadedAnnouncement) = try await (userTask, announcementTask)

            self.user = loadedUser
            self.announcement = loadedAnnouncement
            self.title = loadedAnnouncement.title
            self.description = loadedAnnouncement.description ?? ""
            self.tags = loadedAnnouncement.tags.map { $0.name ?? "" }

        } catch {
            self.error = error
            showAlert(message: "Ошибка при загрузке данных: \(error.localizedDescription)")
        }

        isLoading = false
    }

    @MainActor
    func refresh(announcementId: Int, userId: Int) async {
        guard !isRefreshing else { return }
        isRefreshing = true
        error = nil

        do {
            async let userTask = userClient.getUserById(id: userId)
            async let announcementTask = clientAnnouncement.getFullAnnouncementById(id: announcementId)

            let (loadedUser, loadedAnnouncement) = try await (userTask, announcementTask)

            self.user = loadedUser
            self.announcement = loadedAnnouncement
            self.title = loadedAnnouncement.title
            self.description = loadedAnnouncement.description ?? ""
            self.tags = loadedAnnouncement.tags.map { $0.name ?? "" }

        } catch {
            self.error = error
            showAlert(message: "Ошибка при обновлении данных: \(error.localizedDescription)")
        }

        isRefreshing = false
    }

    // MARK: - User Interaction Methods
    @MainActor
    func respondToAnnouncement(message: String) async {
        guard let announcement else { return }
        isSubmittingResponse = true
        defer { isSubmittingResponse = false }

        do {
            try await responseClient.createResponse(description: message, announcement_id: announcement.id)
            showAlert(message: "Отклик успешно отправлен!")
        } catch {
            showAlert(message: "Ошибка при отклике: \(error.localizedDescription)")
        }
    }
    
    
    @MainActor
    func addToFavorite() async{
        guard let announcement else { return }
        
        do {
            try await favoriteClient.createFavorites(announcement_id: announcement.id)
            showAlert(message: "Успешно добавлено в избраное!")
        } catch {
            self.error = error
            print(error)
            showAlert(message: "Ошибка при добавлении в избранное: \(error.localizedDescription)")
        }
    }
    
//
//    func reportAnnouncement(reason: String) async {
//        guard let announcement = announcement else { return }
//        isReporting = true
//        defer { isReporting = false }
//
//        do {
//            try await clientAnnouncement.reportAnnouncement(id: announcement.id, reason: reason)
//            showAlert(message: "Жалоба отправлена. Спасибо за обратную связь.")
//        } catch {
//            showAlert(message: "Ошибка при отправке жалобы: \(error.localizedDescription)")
//        }
//    }


    // MARK: - Helpers
    private func showAlert(message: String) {
        self.alertMessage = message
        self.showAlert = true
    }
}
