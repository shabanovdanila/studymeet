//
//  MainTabView.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 08.07.2025.
//

import SwiftUI

struct MainTabView: View {
    @Binding var path: NavigationPath
    @Binding var currentScreen: CurrentScreen
    @State private var selectedTab: Tab = .main
    
    enum Tab {
        case main
        case messages
        case search
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Главная вкладка
            MainPageView(path: $path, currentScreen: $currentScreen)
                .tabItem {
                    CustomTabItem(iconName: "house", isSelected: selectedTab == .main)
                }
                .tag(Tab.main)
            
            // Сообщения
            ChatListView(path: $path, currentScreen: $currentScreen)
                .tabItem {
                    CustomTabItem(iconName: "ellipsis.message", isSelected: selectedTab == .messages)
                }
                .tag(Tab.messages)
            
            //
            Text("Search View")
                .tabItem {
                    CustomTabItem(iconName: "magnifyingglass", isSelected: selectedTab == .search)
                }
                .tag(Tab.search)
        }
        .onChange(of: selectedTab) { newValue in
            switch newValue {
            case .main:
                currentScreen = .main
            case .messages:
                currentScreen = .chatList
            case .search:
                break
            }
        }
    }
}

struct CustomTabItem: View {
    let iconName: String
    let isSelected: Bool
    
    var body: some View {
        VStack {
            Image(systemName: iconName)
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(Color.darkBlueSM)
            
            if isSelected {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blueLineSM)
                    .frame(width: 20, height: 2)
            } else {
                Spacer()
                    .frame(height: 2)
            }
        }
        .padding(.top, 10)
    }
}
