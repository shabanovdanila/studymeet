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
        //TODO
        self.totalPage = 10
        self.limit = 10
        self.isLoading = false
        self.gender = nil
        self.min_age = nil
        self.max_age = nil
        self.tags = nil
    }
    
    
    @MainActor
    func loadAnnounces() async {
        guard !isLoading else { return }
        
        isLoading = true
        error = nil
        
        do {
            let response = try await client.getAllAnnouncements(limit: "\(limit)", page: "\(currentPage)")
            print(response)
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

