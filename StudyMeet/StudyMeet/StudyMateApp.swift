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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userSession)
        }
    }
}
