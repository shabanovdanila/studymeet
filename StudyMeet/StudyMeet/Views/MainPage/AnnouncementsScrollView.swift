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
    
    @EnvironmentObject private var userSession: UserSession
    
    init(searchText: Binding<String>, path: Binding<NavigationPath>,
         scrollProxy: Binding<ScrollViewProxy?>) {
        print("CREATING ANNOUNCE SCROLL VIEW")
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
                                choosePath(user_id: announce.user_id, announcementId: announce.id)
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
                print("REFRESHABLE")
                Task {
                    await viewModel.refreshAnnouncements()
                }
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
                Task {
                    await viewModel.loadAnnounces()
                }
            }
            .background(Color.blueBackgroundSM)
        }
        .ignoresSafeArea(.keyboard)
    }
    
    private func choosePath(user_id: Int, announcementId: Int) {
        if let currentUser = userSession.currentUser, currentUser.id == user_id {
            path.append(PathNavigator.ownAnnounce(announcementId: announcementId))
        } else {
            path.append(PathNavigator.anotherAnnounce(announcementId: announcementId, userId: user_id))
        }
    }
}
