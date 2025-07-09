//
//  StudyMateApp.swift
//  StudyMate
//
//  Created by Данила Шабанов on 23.02.2025.
//

import SwiftUI

@main
struct StudyMateApp: App {
    
    @StateObject private var userSession = UserSession.shared
    private let keychainService = KeychainService.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userSession)
            //todo
                .onAppear {
                    if let token = keychainService.getAccessToken() {
                        ChatSocketService.shared.connect(token: token)
                    }
                }
        }
    }
}
