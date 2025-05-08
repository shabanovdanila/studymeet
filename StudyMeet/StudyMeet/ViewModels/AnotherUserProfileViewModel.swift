//
//  AnotherUserProfileViewModel.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 30.04.2025.
//

import Foundation

final class AnotherUserProfileViewModel: ObservableObject {
    private let client: AnnouncClient
    private let userClient: UserClient
    
    @Published var user: User?
    @Published var userAnnouncements: [Announcement] = []
    @Published var error: Error?
    @Published var isLoading: Bool = false
    @Published var isRefreshing: Bool = false
    @Published var currentPage: Int = 1
    
    private var hasMorePages: Bool = true
    private let limit: Int = 10
    
    init(client: AnnouncClient = AnnouncClient(), userClient: UserClient = UserClient()) {
        self.client = client
        self.userClient = userClient
    }
    
    @MainActor
    func loadUserProfile(userId: Int) async {
        guard !isLoading else { return }
        
        isLoading = true
        error = nil
        currentPage = 1
        hasMorePages = true
        userAnnouncements = []
        
        do {
            let user = try await userClient.getUserById(id: userId)
            self.user = user
            print("SUCCESS")
            let announcements = try await client.getAllAnnouncementsByUserId(
                userId: userId,
                limit: "\(limit)",
                page: "\(currentPage)"
            )
            self.userAnnouncements = announcements
            
            hasMorePages = announcements.count >= limit
            
        } catch {
            self.error = error
            print("Failed to load user profile: \(error)")
        }
        
        isLoading = false
    }
    
    @MainActor
    func loadNextPage(userId: Int) async {
        guard !isLoading && hasMorePages else { return }
        
        isLoading = true
        error = nil
        
        do {
            currentPage += 1
            
            let newAnnouncements = try await client.getAllAnnouncementsByUserId(
                userId: userId,
                limit: "\(limit)",
                page: "\(currentPage)"
            )
            
            self.userAnnouncements.append(contentsOf: newAnnouncements)
            
            hasMorePages = newAnnouncements.count >= limit
            
        } catch {
            self.error = error
            print("Failed to load next page: \(error)")
        }
        
        isLoading = false
    }
}
