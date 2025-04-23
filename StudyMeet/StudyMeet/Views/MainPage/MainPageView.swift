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
    
    @Binding var isLogin: Bool
    @State var page1: Bool = true
    @State var searchText: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            TopBarView(path: $path, isLogin: $isLogin, currentScreen: $currentScreen)
                .background(Color.white)
            
            AnnouncementsScrollView(viewModel: .init(client: AnnouncClient()), searchText: $searchText)
            
                .frame(maxWidth: .infinity)
            
            if isLogin {
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
