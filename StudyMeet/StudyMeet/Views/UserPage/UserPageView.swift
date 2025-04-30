//
//  UserPageView.swift
//  StudyMate
//
//  Created by Данила Шабанов on 27.02.2025.
//

import SwiftUI

struct UserPageView: View {
    
    @Binding var path: NavigationPath
    @Binding var currentScreen: CurrentScreen
    
    @State private var selection: Option = .second
    
    let user: User

    
    var body: some View {
        
        VStack(spacing: 0) {
            
            TopBarView(path: $path, currentScreen: $currentScreen)
                .frame(width: 393, height: 50)
                .background(Color.white)
            
                ScrollView(showsIndicators: false) {
                    UserDescriptionView(user: user, whichPage: .ownPage)
                        .padding(.top, 15)
                    
                    SegmentUserView(selection: $selection)
                        .padding([.top], 15)
                       
                    switch selection {
                    case .first:
                        ForEach(0..<6) {_ in
                            AnnounceCardView(announce: Announcement(id: 1, title: "Ищу по англу", bg_color: "hsl(350, 98%, 79%)", user_id: 1, name: "Emilia lin", description: "Hi everyyy", tags: [Tag(id: 1, name: "English", color: "hsl(350, 98%, 79%)")], liked: false))
                                .padding(.top, 15)
                        }
                        .padding(.bottom, 12)
                    case .second: ForEach(0..<2) {_ in
                        AnnounceCardView(announce: Announcement(id: 1, title: "Ищу по англу", bg_color: "hsl(350, 98%, 79%)", user_id: 1, name: "Emilia lin", description: "Hi everyyy", tags: [Tag(id: 1, name: "English", color: "hsl(350, 98%, 79%)")], liked: false))
                            .padding(.top, 15)
                    }
                    .padding(.bottom, 12)
                    }
                }
                .frame(maxWidth: .infinity)
                .background(Color(red: 219 / 255, green: 234 / 255, blue: 254 / 255))
                
                
                if true {
                    BottomBarView(page1: true)
                }
        }
        .background(Color.white)
        .navigationBarBackButtonHidden(true)
        .onAppear() {
            currentScreen = .userOwn
        }
    }
}

