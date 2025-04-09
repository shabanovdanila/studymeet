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
    @Published var totalPage: Int
    @Published var limit: Int
    @Published var isLoading: Bool
    
    init(client: AnnouncClient) {
        self.client = client
        announces = []
        currentPage = 1
        totalPage = 10
        limit = 10
        isLoading = false
    }
    
    
    @MainActor
    func loadAnnounces() async {
        guard !isLoading else { return }
        
        isLoading = true
        error = nil
        
        do {
            let response = try await client.getAllAnnouncements(limit: "\(limit)", page: "\(currentPage)")
            self.announces.append(contentsOf: response)
            // - TODO
            //self.totalPages = response.totalPages
            
        } catch {
            self.error = error
            print(error)
        }
        
        isLoading = false
    }
    
    func loadNextPage() {
        guard currentPage < totalPage else { return }
        currentPage += 1
        Task {
            await loadAnnounces()
        }
    }
}

