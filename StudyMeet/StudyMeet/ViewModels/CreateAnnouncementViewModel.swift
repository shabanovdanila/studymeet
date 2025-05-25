//
//  CreateAnnouncementViewModel.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 02.05.2025.
//

import Foundation

final class CreateAnnouncementViewModel: ObservableObject {
    
    private let client: AnnounceClient
    private let userSession: UserSession = .shared
    
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var tags: [String] = []
    @Published var newTag: String = ""
    
    @Published var isLoading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var creationSuccess: Bool = false
    
    init(client: AnnounceClient = DependencyContainer.shared.makeAnnounceClient()) {
        self.client = client
    }
    
    func addTag() {
        let trimmedTag = newTag.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedTag.isEmpty && !tags.contains(trimmedTag) {
            tags.append(trimmedTag)
            newTag = ""
        }
    }
    
    func removeTag(_ tag: String) {
        tags.removeAll { $0 == tag }
    }
    
    @MainActor
    func createAnnouncement() async {
        guard !title.isEmpty else {
            showAlert(message: "Название объявления не может быть пустым")
            return
        }
        
        guard !description.isEmpty else {
            showAlert(message: "Описание объявления не может быть пустым")
            return
        }
        
        isLoading = true
        
        print(title)
        print(description)
        print(tags)
        
        do {
            try await client.createAnnouncement(
                title: title,
                description: description,
                tags: tags
            )
            
            
            creationSuccess = true
            clearForm()
            showAlert(message: "Объявление успешно создано!")
        } catch {
            showAlert(message: "Ошибка при создании объявления: \(error.localizedDescription)")
            creationSuccess = false
        }
        
        isLoading = false
    }
    
    private func clearForm() {
        title = ""
        description = ""
        tags = []
    }
    
    private func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
}
