//
//  AnnouncementViewModel.swift
//  StudyMate
//
//  Created by Данила Шабанов on 30.03.2025.
//

import Foundation

final class AnnouncementListViewModel: ObservableObject {
    private let client: AnnouncClient
    
    @Published var announces: [Announcement] = []
    @Published var error: Error?
    @Published var currentPage: Int = 1
    @Published var gender: Bool?
    @Published var min_age: Int?
    @Published var max_age: Int?
    @Published var tags: [String]?
    @Published var isLoading: Bool = false
    
    private var limit: Int = 10
    private var hasMorePages: Bool = true
    
    
    init(client: AnnouncClient = AnnouncClient()) {
        self.client = client
    }
    
    @MainActor
    func refreshAnnouncements() async {
        currentPage = 1
        announces = []
        hasMorePages = true
        await loadAnnounces()
    }
    
    @MainActor
    func loadAnnounces() async {
        guard !isLoading && hasMorePages else { return }
        
        isLoading = true
        error = nil
        
        do {
            let response = try await client.getAllAnnouncements(limit: "\(limit)", page: "\(currentPage)")
            
            let newAnnouncements = response.filter { newAnnounce in
                !announces.contains(where: { $0.id == newAnnounce.id })
            }
            
            self.announces.append(contentsOf: newAnnouncements)
            hasMorePages = !response.isEmpty && response.count >= limit
            
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
