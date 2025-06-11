//
//  EditProfileViewModel.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 06.06.2025.
//

import Foundation

final class EditProfileViewModel: ObservableObject {
    private let userClient: UserClient
    private let userSession: UserSession = .shared
    
    @Published var name: String = ""
    @Published var location: String = ""
    @Published var birthday: String = ""
    @Published var gender: Bool = true // false - женский, true - мужской
    @Published var description: String = ""
    @Published var created_at: String = ""
    
    @Published var isLoading: Bool = false
    @Published var error: Error?
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var updateSuccess: Bool = false
    
    init(userClient: UserClient = DependencyContainer.shared.makeUserClient()) {
        self.userClient = userClient
        loadCurrentUserData()
    }
    
    private func loadCurrentUserData() {
        guard let user = userSession.currentUser else { return }
        created_at = user.created_at ?? ""
        name = user.name
        location = user.location ?? ""
        description = user.description ?? ""
        gender = user.gender ?? true
        birthday = user.birthday ?? ""
    }
    
    @MainActor
    func updateProfile() async {
        guard !isLoading else { return }
        
        isLoading = true
        error = nil
        
        let newDate = convertToISO8601(from: birthday) ?? birthday
        do {
            
            try await userClient.updateUser(
                name: name,
                location: location,
                gender: gender,
                birthday: newDate,
                description: description
            )
            userSession.updateUser(name: name, location: location, gender: gender, birtday: birthday, description: description)
            updateSuccess = true
            showAlert(message: "Профиль успешно обновлен")
            
        } catch {
            self.error = error
            showAlert(message: "Ошибка при обновлении профиля: \(error.localizedDescription)")
            updateSuccess = false
        }
        
        isLoading = false
    }
    
    @MainActor
    func deleteProfileImage() async {
        // Реализация удаления изображения профиля
    }
    
    @MainActor
    func uploadProfileImage(imageData: Data) async {
        // Реализация загрузки нового изображения профиля
    }
    
    private func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
}
