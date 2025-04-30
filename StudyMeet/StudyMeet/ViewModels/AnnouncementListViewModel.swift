//
//  AnnouncementViewModel.swift
//  StudyMate
//
//  Created by Данила Шабанов on 30.03.2025.
//

import Foundation

class AnnouncementListViewModel: ObservableObject {
    let client: AnnouncClient
    
    @Published var announces: [Announcement]
    @Published var error: Error?
    @Published var currentPage: Int
    @Published var hasMorePages: Bool
    @Published var gender: Bool?
    @Published var min_age: Int?
    @Published var max_age: Int?
    @Published var tags: [String]?
    @Published var limit: Int
    @Published var isLoading: Bool
    
    init(client: AnnouncClient = AnnouncClient()) {
        self.client = client
        self.announces = []
        self.currentPage = 1
        self.hasMorePages = true
        self.limit = 10
        self.isLoading = false
    }
    
    @MainActor
    func loadAnnounces() async {
        guard !isLoading && hasMorePages else { return }
        
        isLoading = true
        error = nil
        
        do {
            let response = try await client.getAllAnnouncements(limit: "\(limit)", page: "\(currentPage)")
            if response.isEmpty {
                hasMorePages = false
            } else {
                self.announces.append(contentsOf: response)
                if response.count < limit {
                    hasMorePages = false
                }
            }
        } catch {
            self.error = error
            print(error)
        }
        
        isLoading = false
    }
    
    func loadNextPage() {
        guard hasMorePages else { return }
        currentPage += 1
        Task {
            await loadAnnounces()
        }
    }
}
