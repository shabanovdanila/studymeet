//
//  FavoritesViewModel.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 11.04.2025.
//

import Foundation


class FavoritesViewModel: ObservableObject {
    let client: FavoriteClient 
    let user_id: Int
    
    @Published var favorites: [Announcement]
    @Published var error: Error?
    @Published var currentPage: Int
    @Published var totalPage: Int
    @Published var limit: Int
    @Published var isLoading: Bool
    
    init(client: FavoriteClient = FavoriteClient(), user_id: Int) {
        self.client = client
        self.favorites = []
        self.currentPage = 1
        //TODO
        self.totalPage = 10
        self.limit = 10
        self.isLoading = false
        self.user_id = user_id
        
    }
    
    @MainActor
    func loadFavorites() async {
        guard !isLoading else { return }
        
        isLoading = true
        error = nil
        
        do {
            let response = try await client.getFavoritesByUserId(user_id: user_id, limit: "\(limit)", page: "\(currentPage)")
            self.favorites.append(contentsOf: response)
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
            await loadFavorites()
        }
    }
}
