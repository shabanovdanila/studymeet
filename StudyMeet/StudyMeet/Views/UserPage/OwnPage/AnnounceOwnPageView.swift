//
//  AnnounceOwnPageView.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 30.04.2025.
//

import SwiftUI

struct AnnounceOwnPageView: View {
    let announcementId: Int
    
    @StateObject private var viewModelCreationAnnounce: CreateAnnouncementViewModel
    @StateObject private var viewModel: AnnounceOwnPageViewModel
    
    @Binding var path: NavigationPath
    @Binding var currentScreen: CurrentScreen
    
    @State private var showCreateModal = false

    
    init(path: Binding<NavigationPath>, currentScreen: Binding<CurrentScreen>, announcementId: Int) {
        self._path = path
        self._currentScreen = currentScreen
        self._viewModelCreationAnnounce = StateObject(wrappedValue: CreateAnnouncementViewModel())
        self._viewModel = StateObject(wrappedValue: AnnounceOwnPageViewModel())
        self.announcementId = announcementId
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TopBarView(path: $path, currentScreen: $currentScreen, onCreateButtonTapped: { showCreateModal = true })
                .frame(width: 393, height: 50)
                .background(Color.white)
            
            ScrollView(showsIndicators: false) {
                // Информация о пользователе
                if let user = viewModel.user, let announcement = viewModel.announcement {
                    OwnDescriptionView(user: user)
                        .padding(.top, 15)
                    
                    FullAnnounceCardView(announce: announcement)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.graySM, lineWidth: 1)
                        )
                        .padding()
                    
                    Text("Отклики (\(viewModel.responses.count))")
                        .foregroundColor(Color.darkBlueSM)
                        .font(.custom("Montserrat-SemiBold", size: 20))
                        .padding(.top, 15)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack {
                        ForEach(viewModel.responses) { response in
                            VStack(spacing: 0) {
                                ResponseCardView(response: response)
                                    .background(Color.white)
                                    .padding(15)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.graySM, lineWidth: 1)
                                    )
                                    .padding(.bottom, 10)
                            }

                        }
                    }
                    
                } else {
                    UserProfilePlaceholder()
                        .padding(.top, 15)
                }
                
                // Индикатор загрузки для подгрузки
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.blueBackgroundSM)
            
            BottomBarView(page1: true)
        }
        .background(Color.white)
        .fullScreenCover(isPresented: $showCreateModal) {
            CreateAnnouncementModal(viewModel: viewModelCreationAnnounce)
                .edgesIgnoringSafeArea(.all)
        }
        .refreshable {
            Task {
                await viewModel.refresh(announcementId: announcementId)
            }
        }
        .task {
            if viewModel.user == nil {
                await viewModel.loadAnnouncementProfile(announcementId: announcementId)
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
        }
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

private struct FullAnnounceCardView: View {
    var announce: Announcement
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text(announce.title)
                        .foregroundColor(Color.black)
                        .font(.custom("Montserrat-SemiBold", size: 20))
                    Spacer()
                    Image(systemName: "heart")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                }
                .frame(height: 49)
                .padding(15)
                
                line()
                
            }
            VStack(alignment: .leading, spacing: 0) {
                Text("Кого ищу?")
                    .foregroundColor(Color.black)
                    .font(.custom("Montserrat-SemiBold", size: 18))
                Text(announce.description ?? "")
                    .foregroundColor(Color.black)
                    .font(.custom("Montserrat-Regular", size: 14))
                    .padding(.top, 15)
                tagsView(tags: announce.tags)
                    .padding(.top, 10)
                
                Button("Редактировать") {
                    //                Task {
                    //                    await viewModel.updateProfile()
                    //                    if viewModel.updateSuccess {
                    //                        dismiss()
                    //                    }
                    //                }
                }
                .padding(.horizontal, 20)
                .frame(height: 44)
                .background(Color.grayTextSM)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.top, 15)
            }
            .padding(15)
        }
    }
    @ViewBuilder
    private func line() -> some View {
        RoundedRectangle(cornerRadius: 10)
                .fill(Color.graySM)
                .frame(width: 333, height: 1, alignment: .center)
    }
    
    private struct tagsView: View {
        var tags: [Tag]
        var body: some View {
            HStack {
                if (!(tags).isEmpty) {
                    ForEach(tags) {tag in
                        Text("#" + (tag.name ?? ""))
                            .foregroundColor(Color.black)
                            .font(.custom("Montserrat-Regular", size: 10))
                            .padding([.top, .bottom], 3)
                            .padding([.trailing, .leading], 6)
                            .background(ColorHSLConverter.getHslColor(colorhsl: tag.color ?? ""))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                } else {
                    Text("#")
                        .foregroundColor(Color.black)
                        .font(.custom("Montserrat-Regular", size: 10))
                        .padding([.top, .bottom], 3)
                        .padding([.trailing, .leading], 6)
                    
                    //TODO
                        .background(Color(r: 255, g: 139, b: 139))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
    }
}

private struct ResponseCardView: View {
    var response: Response
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                avatar
                    .padding([.trailing], 5)
                Text(response.name)
                    .foregroundColor(Color.black)
                    .font(.custom("Montserrat-Regular", size: 16))
                Spacer()
                
                Image(systemName: "xmark")
                    .foregroundStyle(Color.red)
                    .padding(.bottom, 10)
                    .padding(.trailing, 19)
                Image(systemName: "checkmark")
                    .foregroundStyle(Color.green)
                    .padding(.bottom, 10)
            }
            Text(response.description)
                .foregroundColor(Color.black)
                .font(.custom("Montserrat-Regular", size: 14))
                .padding(.top, 4)
        }
    }
    
    private var avatar: some View {
        Image(systemName: "cat.fill")
            .resizable()
            .padding(3)
            .frame(width: 14, height: 14)
            .background(Color.yellow)
            .clipShape(Circle())
    }
}


