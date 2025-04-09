//
//  AnnouncementsScrollView.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 08.04.2025.
//

import SwiftUI
//
//struct AnnouncementsScrollView: View {
//    
//    @StateObject private var annoncewViewModel: AnnouncementListViewModel
//    @Binding var searchText: String
//    
//    init(annoncewViewModel: AnnouncementListViewModel, searchText: Binding<String>) {
//        self._annoncewViewModel = .init(wrappedValue: annoncewViewModel)
//        self._searchText = searchText
//    }
//    
//    var body: some View {
//        ScrollView(showsIndicators: false) {
//            VStack {
//                SearcherView(searchText: $searchText)
//                    .padding(.top, 15)
//                
//                
//                
//                ForEach(0..<6) {_ in
//                    AnnounceCardView(announce: Announcement(id: 1, title: "Ищу по англу", bg_color: "hsl(350, 98%, 79%)", user_id: 1, user_name: "Emilia lin", description: "Hi everyyy", tags: [Tag(id: 1, name: "English", color: "hsl(350, 98%, 79%)")], liked: false))
//                        .padding(.top, 15)
//                }
//            }
//            .padding(.bottom, 12)
//        }
//    }
//}

struct AnnouncementsScrollView: View {
    @StateObject private var viewModel: AnnouncementListViewModel
    @Binding var searchText: String
    
    init(viewModel: AnnouncementListViewModel, searchText: Binding<String>) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._searchText = searchText
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
                LazyVStack {
                    SearcherView(searchText: $searchText)
                        .padding(.top, 15)
                    
                    ForEach(viewModel.announces) { announce in
                        AnnounceCardView(announce: announce)
                            .padding(.top, 15)
                            .onAppear {
                                // Загружаем следующую страницу, когда пользователь доскроллил до последнего элемента
                                if announce.id == viewModel.announces.last?.id {
                                    viewModel.loadNextPage()
                                }
                            }
                    }
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    }
                }
                .padding(.bottom, 12)
            }
            .refreshable {
                Task {
                    await viewModel.loadAnnounces()
                }
            }
            .task {
                // Первоначальная загрузка данных
                await viewModel.loadAnnounces()
            }
            .alert("Error", isPresented: .constant(viewModel.error != nil)) {
                Button("OK", role: .cancel) { }
                Button("Retry") {
                    Task {
                        await viewModel.loadAnnounces()
                    }
                }
            } message: {
                Text(viewModel.error?.localizedDescription ?? "Unknown error")
            }
            .background(Color(red: 219 / 255, green: 234 / 255, blue: 254 / 255))
    }
}
