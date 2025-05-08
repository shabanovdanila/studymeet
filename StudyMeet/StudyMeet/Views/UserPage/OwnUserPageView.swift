//
//  OwnUserPageView.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 02.05.2025.
//
import SwiftUI

struct OwnUserPageView: View {
    
    @StateObject private var viewModel: OwnUserPageViewModel
    @StateObject private var viewModelCreationAnnounce: CreateAnnouncementViewModel
    
    @Binding var path: NavigationPath
    @Binding var currentScreen: CurrentScreen
    
    @EnvironmentObject private var modalState: ModalStateManager
    
    @State private var selection: Option = .first
    
    init(path: Binding<NavigationPath>, currentScreen: Binding<CurrentScreen>) {
        self._path = path
        self._currentScreen = currentScreen
        self._viewModel = StateObject(wrappedValue: OwnUserPageViewModel())
        self._viewModelCreationAnnounce = StateObject(wrappedValue: CreateAnnouncementViewModel())
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TopBarView(path: $path, currentScreen: $currentScreen)
                .frame(width: 393, height: 50)
                .background(Color.white)
            
            ScrollView(showsIndicators: false) {
                // Информация о пользователе
                if let user = viewModel.user {
                    UserDescriptionView(user: user, whichPage: .ownPage)
                        .padding(.top, 15)
                        .transition(.opacity)
                } else {
                    UserProfilePlaceholder()
                        .padding(.top, 15)
                }
                
                SegmentUserView(selection: $selection)
                    .padding(.top, 15)
                
                // Контент в зависимости от выбора
                Group {
                    switch selection {
                    case .first: // Мои объявления
                        if viewModel.userAnnouncements.isEmpty && viewModel.isLoading {
                            AnnouncementsPlaceholder()
                        } else if viewModel.userAnnouncements.isEmpty {
                            EmptyStateView(type: .myAnnouncements)
                        } else {
                            announcementsList
                        }
                        
                    case .second: // Избранные
                        if viewModel.favoriteAnnouncements.isEmpty && viewModel.isLoading {
                            AnnouncementsPlaceholder()
                        } else if viewModel.favoriteAnnouncements.isEmpty {
                            EmptyStateView(type: .favorites)
                        } else {
                            favoritesList
                        }
                    }
                }
                .animation(.default, value: selection)
                
                // Индикатор загрузки для подгрузки
                if viewModel.isLoading && (viewModel.currentPage > 1 || viewModel.favoritesCurrentPage > 1) {
                    ProgressView()
                        .padding()
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color(red: 219/255, green: 234/255, blue: 254/255))
            
            BottomBarView(page1: true)
        }
        .background(Color.white)
        .fullScreenCover(isPresented: $modalState.showCreateAnnouncement) {
            CreateAnnouncementModal(viewModel: viewModelCreationAnnounce)
                .edgesIgnoringSafeArea(.all)
        }
        .refreshable {
            Task {
                await viewModel.refresh()
            }
        }
        .task {
            if viewModel.user == nil {
                await viewModel.loadUserProfile()
            }
        }
        .alert("Ошибка", isPresented: .constant(viewModel.error != nil)) {
            Button("OK", role: .cancel) { viewModel.error = nil }
        } message: {
            Text(viewModel.error?.localizedDescription ?? "Неизвестная ошибка")
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            currentScreen = .userOwn
            print("!!!!!!!!!!!!!OwnUserPageView appeared!!!!!!!!!!!!!")
        }
        .onDisappear { print("!!!!!!!!!!!!OwnUserPageView disappeared!!!!!!!!!!!!!") }
    }
    
    private var announcementsList: some View {
        ForEach(viewModel.userAnnouncements) { announce in
            AnnounceCardView(announce: announce)
                .padding(.top, 15)
                .onAppear {
                    if announce.id == viewModel.userAnnouncements.last?.id && !viewModel.isLoading {
                        Task {
                            await viewModel.loadNextPage()
                        }
                    }
                }
        }
        .padding(.bottom, 12)
    }
    
    private var favoritesList: some View {
        ForEach(viewModel.favoriteAnnouncements) { announce in
            AnnounceCardView(announce: announce)
                .padding(.top, 15)
                .onAppear {
                    if announce.id == viewModel.favoriteAnnouncements.last?.id && !viewModel.isLoading {
                        Task {
                            await viewModel.loadNextFavoritesPage()
                        }
                    }
                }
        }
        .padding(.bottom, 12)
    }
}

// MARK: - Placeholder Views

private struct UserProfilePlaceholder: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Аватар и основная информация
            HStack(spacing: 16) {
                RoundedRectangle(cornerRadius: 40)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 80, height: 80)
                
                VStack(alignment: .leading, spacing: 8) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 150, height: 20)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 200, height: 16)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 100, height: 14)
                }
            }
            .padding(.horizontal, 16)
            
            // Описание
            VStack(alignment: .leading, spacing: 8) {
                ForEach(0..<3) { _ in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 12)
                }
            }
            .padding(.horizontal, 16)
        }
        .redacted(reason: .placeholder)
    }
}

private struct AnnouncementsPlaceholder: View {
    var body: some View {
        VStack(spacing: 15) {
            ForEach(0..<3) { _ in
                VStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 120)
                    
                    HStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 100, height: 20)
                        
                        Spacer()
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 60, height: 20)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .redacted(reason: .placeholder)
    }
}

struct EmptyStateView: View {
    enum EmptyStateType {
        case myAnnouncements
        case favorites
        
        var title: String {
            switch self {
            case .myAnnouncements: return "У вас пока нет объявлений"
            case .favorites: return "В избранном пусто"
            }
        }
        
        var subtitle: String {
            switch self {
            case .myAnnouncements: return "Создайте первое объявление, нажав на кнопку ниже"
            case .favorites: return "Добавляйте понравившиеся объявления в избранное"
            }
        }
    }
    
    let type: EmptyStateType
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: type == .myAnnouncements ? "doc.plaintext" : "heart")
                .font(.system(size: 48))
                .foregroundColor(.gray.opacity(0.5))
                .padding(.bottom, 8)
            
            Text(type.title)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.gray)
            
            Text(type.subtitle)
                .font(.system(size: 14))
                .foregroundColor(.gray.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding(.vertical, 40)
        .frame(maxWidth: .infinity)
    }
}
