//
//  AnnounceAnotherPageView.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 17.04.2025.
//

import SwiftUI

import SwiftUI

import SwiftUI

struct AnnounceAnotherPageView: View {
    let announcementId: Int
    let userId: Int
    
    @StateObject private var viewModel: AnnounceAnotherPageViewModel
    @StateObject private var viewModelCreationAnnounce: CreateAnnouncementViewModel
    
    
    @Binding var path: NavigationPath
    @Binding var currentScreen: CurrentScreen
    
    @State private var showCreateModal = false
    @State private var showReportAlert = false
    @State private var showRespondModal = false
    @State private var responseText: String = ""
    
    init(path: Binding<NavigationPath>, currentScreen: Binding<CurrentScreen>, announcementId: Int, userId: Int) {
        self._path = path
        self._currentScreen = currentScreen
        self.announcementId = announcementId
        self.userId = userId
        self._viewModelCreationAnnounce = StateObject(wrappedValue: CreateAnnouncementViewModel())
        self._viewModel = StateObject(wrappedValue: AnnounceAnotherPageViewModel())
    }

    var body: some View {
        VStack(spacing: 0) {
            TopBarView(path: $path, currentScreen: $currentScreen, onCreateButtonTapped: {
                showCreateModal = true
            })
                .frame(width: 393, height: 50)
                .background(Color.white)

            ScrollView(showsIndicators: false) {
                if let user = viewModel.user, let announcement = viewModel.announcement {
                    OwnDescriptionView(user: user)
                        .padding(.top, 15)

                    FullAnnounceCardView(announce: announcement, viewModel: viewModel, showReportAlert: $showReportAlert, showRespondModal: $showRespondModal)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.graySM, lineWidth: 1)
                        )
                        .padding()
                } else {
                    UserProfilePlaceholder()
                        .padding(.top, 15)
                }

                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.blueBackgroundSM)

        }
        .background(Color.white)
        .refreshable {
            await viewModel.refresh(announcementId: announcementId, userId: userId)
        }
        .task {
            await viewModel.loadAnnouncementProfile(announcementId: announcementId, userId: userId)
        }
        .alert("Пожаловаться на объявление?", isPresented: $showReportAlert) {
            Button("Отмена", role: .cancel) {}
            Button("Пожаловаться", role: .destructive) {
                //Task {
                    //await viewModel.reportAnnouncement(reason: "Нарушение правил")
               // }
            }
        }
        .alert("Сообщение", isPresented: $viewModel.showAlert) {
            Button("ОК", role: .cancel) {}
        } message: {
            Text(viewModel.alertMessage)
        }
        .fullScreenCover(isPresented: $showRespondModal) {
            VStack(spacing: 20) {
                Text("Отклик на объявление")
                    .font(.title2)
                    .bold()
                
                TextEditor(text: $responseText)
                    .frame(height: 150)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3)))
                
                Button("Отправить") {
                    Task {
                        await viewModel.respondToAnnouncement(message: responseText)
                        showRespondModal = false
                        responseText = ""
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.darkBlueSM)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                
                Button("Отмена") {
                    showRespondModal = false
                }
                .foregroundColor(.red)
                
                Spacer()
            }
            .padding()
        }
        .fullScreenCover(isPresented: $showCreateModal) {
            CreateAnnouncementModal(viewModel: viewModelCreationAnnounce)
                .edgesIgnoringSafeArea(.all)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            currentScreen = .anotherAnnounce
        }
    }
}

private struct FullAnnounceCardView: View {
    var announce: Announcement
    
    @ObservedObject var viewModel: AnnounceAnotherPageViewModel
    @Binding var showReportAlert: Bool
    @Binding var showRespondModal: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text(announce.title)
                        .foregroundColor(Color.black)
                        .font(.custom("Montserrat-SemiBold", size: 20))
                    Spacer()
                    Button(action: {
                        Task {
                            await viewModel.addToFavorite()
                        }
                    }) {
                        Image(systemName: "heart")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                    }
                }
                .frame(maxHeight: .infinity)
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
                
                HStack(spacing: 0) {
                    Button(action: {
                        showRespondModal = true
                    }) {
                        Text("Откликнуться")
                            .font(.custom("Montserrat-Medium", size: 16))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding([.top, .bottom], 12)
                            .padding([.horizontal, .trailing], 20)
                            .background(Color.lightBlueSM)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    Spacer()
                    Button(action: {
                        showReportAlert = true
                    }) {
                        Text("Пожаловаться")
                            .font(.custom("Montserrat-Medium", size: 16))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding([.top, .bottom], 12)
                            .padding([.horizontal, .trailing], 20)
                            .background(Color.redReportSM)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                }
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


private struct UserProfilePlaceholder: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
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
