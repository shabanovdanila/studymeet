//
//  AnnouncementsScrollView.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 08.04.2025.
//

import SwiftUI

struct AnnouncementsScrollView: View {
    
    @StateObject private var viewModel = AnnouncementListViewModel()
    @Binding var searchText: String
    @Binding var path: NavigationPath
    
    @Binding var scrollProxy: ScrollViewProxy?
    
    init(searchText: Binding<String>, path: Binding<NavigationPath>,
         scrollProxy: Binding<ScrollViewProxy?>) {
        self._searchText = searchText
        self._path = path
        self._scrollProxy = scrollProxy
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            
            ScrollView(showsIndicators: false) {
                Text("").id("top")
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
                    await viewModel.refreshAnnouncements()
                }
            }
            .task {
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
            .onAppear() {
                scrollProxy = proxy
            }
            .background(Color(red: 219 / 255, green: 234 / 255, blue: 254 / 255))
        }
    }
}
