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
    @Published var canLoadMore: Bool
    @Published var error: Error?
    private var nextPage: Int?
    
    init(client: AnnouncClient, announce: Announcement) {
        self.client = client
        announces = []
        canLoadMore = true
    }
    
    
//    func loadNext() async {
//        guard canLoadMore else {
//            return
//        }
//        do {
//            let result: AllAnnouncements
//            if let nextPage {
//                result = try await client.getAllAnnouncements(limit: 10, page: nextPage)
//            } else {
//                result = try await client.getAllAnnouncements(limit: 10, page: 1)
//                nextPage = 2
//            }
//            await MainActor.run {
//                if let nextPage {
//                    canLoadMore = self.nextPage != nil
//                    characters.append(contentsOf: result.results)
//                }
//            } catch {
//                print(error)
//                await MainActor.run {
//                    self.error = error
//                }
//            }
//        }
//        
//    }
}

