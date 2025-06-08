//
//  OwnPageViewModel.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 02.05.2025.
//

import Foundation

final class OwnUserPageViewModel: ObservableObject {
    private let clientAnnouncement: AnnounceClient
    private let clientFavorites: FavoriteClient
    private let userClient: UserClient
    
    private let userSession: UserSession = .shared
    
    @Published var user: User?
    @Published var userAnnouncements: [Announcement] = []
    @Published var favoriteAnnouncements: [Announcement] = []
    @Published var error: Error?
    @Published var isLoading: Bool = false
    @Published var isRefreshing: Bool = false

    @Published var currentPage: Int = 1
    @Published var favoritesCurrentPage: Int = 1
    
    private var hasMorePages: Bool = true
    private var hasMoreFavoritesPages: Bool = true
    private let limit: Int = 10
    
    init(clientAnnouncement: AnnounceClient = DependencyContainer.shared.makeAnnounceClient(),
         clientFavorites: FavoriteClient = DependencyContainer.shared.makeFavoriteClient(),
         userClient: UserClient = DependencyContainer.shared.makeUserClient()) {
        self.clientAnnouncement = clientAnnouncement
        self.clientFavorites = clientFavorites
        self.userClient = userClient
    }
    
    @MainActor
    func loadUserProfile() async {
        guard let userId = userSession.currentUser?.id else { return }
        guard !isLoading else { return }
        
        isLoading = true
        error = nil
        currentPage = 1
        favoritesCurrentPage = 1
        hasMorePages = true
        hasMoreFavoritesPages = true
        userAnnouncements = []
        favoriteAnnouncements = []
        
        do {
            self.user = try await userClient.getUserById(id: userId)
            print("SUCCESS USER")
            let announcements = try await clientAnnouncement.getAllAnnouncementsByUserId(
                userId: userId,
                limit: "\(limit)",
                page: "\(currentPage)"
            )
            print("SUCCESS ANNOUNCE")
            let favorites = try await clientFavorites.getFavoritesByUserId(
                limit: "\(limit)",
                page: "\(favoritesCurrentPage)"
            )
            print("SUCCESS FAVORITES")
            
            self.userAnnouncements = announcements
            self.favoriteAnnouncements = favorites
            userSession.updateUser(created_at: parseDateString(user?.created_at ?? ""))
            
            hasMorePages = userAnnouncements.count >= limit
            hasMoreFavoritesPages = favoriteAnnouncements.count >= limit
            
        } catch {
            self.error = error
            print("Failed to load user profile: \(error)")
        }
        
        isLoading = false
    }
    
    @MainActor
    func loadNextPage() async {
        guard let userId = userSession.currentUser?.id else { return }
        guard !isLoading && hasMorePages else { return }
        
        isLoading = true
        error = nil
        
        do {
            currentPage += 1
            
            let newAnnouncements = try await clientAnnouncement.getAllAnnouncementsByUserId(
                userId: userId,
                limit: "\(limit)",
                page: "\(currentPage)"
            )
            
            self.userAnnouncements.append(contentsOf: newAnnouncements)
            hasMorePages = newAnnouncements.count >= limit
            
        } catch {
            currentPage -= 1
            self.error = error
            print("Failed to load next page: \(error)")
        }
        
        isLoading = false
    }
    
    @MainActor
    func loadNextFavoritesPage() async {
        guard !isLoading && hasMoreFavoritesPages else { return }
        
        isLoading = true
        error = nil
        
        do {
            favoritesCurrentPage += 1
            
            let newFavorites = try await clientFavorites.getFavoritesByUserId(
                limit: "\(limit)",
                page: "\(favoritesCurrentPage)"
            )
            
            self.favoriteAnnouncements.append(contentsOf: newFavorites)
            hasMoreFavoritesPages = newFavorites.count >= limit
            
        } catch {
            favoritesCurrentPage -= 1
            self.error = error
            print("Failed to load next favorites page: \(error)")
        }
        
        isLoading = false
    }
    
    @MainActor
    func refresh() async {
        guard !isRefreshing else { return }
        
        isRefreshing = true
        await loadUserProfile()
        isRefreshing = false
    }
}
