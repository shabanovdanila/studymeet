//
//  AnnouncementsScrollView.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 08.04.2025.
//

import SwiftUI

struct AnnouncementsScrollView: View {
    
    @StateObject private var viewModel: AnnouncementListViewModel
    @Binding var searchText: String
    @Binding var path: NavigationPath
    
    init(viewModel: AnnouncementListViewModel, searchText: Binding<String>, path: Binding<NavigationPath>) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._searchText = searchText
        self._path = path
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
                                if announce.id == viewModel.announces.last?.id {
                                    viewModel.loadNextPage()
                                }
                            }
                            .onTapGesture {
                                path.append(Path.userAnother(userId: announce.user_id))
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
