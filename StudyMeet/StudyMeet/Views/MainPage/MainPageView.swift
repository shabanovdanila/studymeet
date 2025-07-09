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
    
    @State private var showCreateModal = false
    
    @State var page1: Bool = true
    @State var searchText: String = ""
    @State private var scrollProxy: ScrollViewProxy?
    
    
    var body: some View {
        VStack(spacing: 0) {
            TopBarView(path: $path, currentScreen: $currentScreen,
                       onCreateButtonTapped: { showCreateModal = true },
                       scrollToTop: {
                withAnimation(.smooth) {
                    scrollProxy?.scrollTo("top", anchor: .top)
                }})
                .background(Color.white)
            
            Button("logout") {
                //TODO добавить лог аут на сервер
                userSession.logout()
            }
            AnnouncementsScrollView(searchText: $searchText, path: $path, scrollProxy: $scrollProxy)
                .frame(maxWidth: .infinity)
            
        }
        .background(Color.white)
        .fullScreenCover(isPresented: $showCreateModal) {
            CreateAnnouncementModal()
                .edgesIgnoringSafeArea(.all)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            currentScreen = .main
            print("CREATING MAINPAGEVIEW")
        }
        .ignoresSafeArea(.keyboard)
    }
}
