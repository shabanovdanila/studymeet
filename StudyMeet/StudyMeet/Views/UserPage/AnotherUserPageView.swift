//
//  AnotherUserPageView.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 30.04.2025.
//

import SwiftUI

struct AnotherUserPageView: View {
    let userId: Int
    
    @StateObject private var viewModel: AnotherUserProfileViewModel
    @StateObject private var viewModelCreationAnnounce: CreateAnnouncementViewModel
    
    @State private var showCreateModal = false
    
    @Binding var path: NavigationPath
    @Binding var currentScreen: CurrentScreen
    
    init(userId: Int, path: Binding<NavigationPath>, currentScreen: Binding<CurrentScreen>) {
        self.userId = userId
        self._path = path
        self._currentScreen = currentScreen
        self._viewModel = StateObject(wrappedValue: AnotherUserProfileViewModel())
        self._viewModelCreationAnnounce = StateObject(wrappedValue: CreateAnnouncementViewModel())
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            TopBarView(path: $path, currentScreen: $currentScreen, onCreateButtonTapped: { showCreateModal = true})
                .frame(width: 393, height: 50)
                .background(Color.white)
            
            ScrollView(showsIndicators: false) {
                
                if let user = viewModel.user {
                    UserDescriptionView(user: user, whichPage: .anotherPage)
                        .padding(.top, 15)
                        .transition(.opacity)
                } else if viewModel.isLoading && viewModel.currentPage == 1 {
                    UserProfilePlaceholder()
                        .padding(.top, 15)
                }
                
                if !viewModel.userAnnouncements.isEmpty {
                    
                    ForEach(viewModel.userAnnouncements) { announce in
                        AnnounceCardView(announce: announce)
                            .padding(.top, 15)
                            .onAppear {
                                if announce.id == viewModel.userAnnouncements.last?.id && !viewModel.isLoading {
                                    Task {
                                        await viewModel.loadNextPage(userId: userId)
                                    }
                                }
                            }
                    }
                    .padding(.bottom, 12)
                } else if viewModel.isLoading {
                    ProgressView()
                }
                
                if viewModel.isLoading && viewModel.currentPage > 1 {
                    ProgressView()
                        .padding()
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.blueBackgroundSM)
            BottomBarView(page1: true)
        }
        .background(Color(.white))
        .refreshable {
            Task {
                await viewModel.loadUserProfile(userId: userId)
            }
        }
        .task {
            await viewModel.loadUserProfile(userId: userId)
        }
        .alert("Ошибка", isPresented: .constant(viewModel.error != nil)) {
            Button("OK", role: .cancel) { viewModel.error = nil }
        } message: {
            Text(viewModel.error?.localizedDescription ?? "Неизвестная ошибка")
        }
        .fullScreenCover(isPresented: $showCreateModal) {
            CreateAnnouncementModal(viewModel: viewModelCreationAnnounce)
                .edgesIgnoringSafeArea(.all)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear() {
            currentScreen = .userAnother
        }
    }
}

private struct UserProfilePlaceholder: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal, 16)
            
            VStack(alignment: .leading, spacing: 8) {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 200, height: 24)
                
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 150, height: 16)
            }
            .padding(.horizontal, 16)
            
            Spacer()
        }
        .redacted(reason: .placeholder)
        .padding(.bottom, 20)
    }
}
