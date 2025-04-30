//
//  MainPageView.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 10.04.2025.
//

import SwiftUI

struct MainPageView: View {
    
    @Binding var path: NavigationPath
    @Binding var currentScreen: CurrentScreen
    @EnvironmentObject private var userSession: UserSession
    
    @State var page1: Bool = true
    @State var searchText: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            TopBarView(path: $path, currentScreen: $currentScreen)
                .background(Color.white)
            
            AnnouncementsScrollView(viewModel: .init(client: AnnouncClient()), searchText: $searchText, path: $path)
            
                .frame(maxWidth: .infinity)
            
            if userSession.isAuthenticated {
                BottomBarView(page1: page1)
            }
        }
        .background(Color.white)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            currentScreen = .main
        }
    }
}
