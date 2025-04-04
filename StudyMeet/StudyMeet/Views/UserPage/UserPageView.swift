//
//  UserPageView.swift
//  StudyMate
//
//  Created by Данила Шабанов on 27.02.2025.
//

import SwiftUI

struct UserPageView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var selection: Option = .second
    
    var body: some View {
        
        VStack(spacing: 0) {
            TopBarView(isLogin: true, isInUserPageView: true)
                .frame(width: 393, height: 50)
                .background(Color.white)
            
            
            NavigationStack {
                ScrollView(showsIndicators: false) {
                    UserDescriptionView(user: User(id: 1, email: "", password: "", name: "", username: "", description: "", location: "", gender: true, birthday: "", created_at: ""))
                        .padding(.top, 15)
                    
                    SegmentUserView(selection: $selection)
                        .padding([.top], 15)
                       
                    switch selection {
                    case .first:
                        ForEach(0..<6) {_ in
                            AnnounceCardView(announce: Announcement(id: 1, title: "Ищу по англу", bg_color: "hsl(350, 98%, 79%)", user_id: 1, user_name: "Emilia lin", description: "Hi everyyy", tags: [Tag(id: 1, name: "English", color: "hsl(350, 98%, 79%)")], liked: false))
                                .padding(.top, 15)
                        }
                        .padding(.bottom, 12)
                    case .second: ForEach(0..<2) {_ in
                        AnnounceCardView(announce: Announcement(id: 1, title: "Ищу по англу", bg_color: "hsl(350, 98%, 79%)", user_id: 1, user_name: "Emilia lin", description: "Hi everyyy", tags: [Tag(id: 1, name: "English", color: "hsl(350, 98%, 79%)")], liked: false))
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
        }
        .background(Color.white)
    }
}

#Preview {
    UserPageView()
}
