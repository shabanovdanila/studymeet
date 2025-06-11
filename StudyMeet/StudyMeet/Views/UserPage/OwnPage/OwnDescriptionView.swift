//
//  OwnDescriptionView.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 08.06.2025.
//

import SwiftUI

struct OwnDescriptionView: View {
    let user: User
    
    @State private var hiddenFullInfo: Bool = true
    @State var showEditProfileModal: Bool = false
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            ZStack(alignment: .center) {
                Circle()
                    .foregroundStyle(Color.white)
                    .frame(width: 100, height: 100)
                
                Image(systemName: "cat.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(10)
                    .frame(width: 95, height: 95)
                    .background(Color.yellow)
                    .clipShape(Circle())
            }
            .padding(.horizontal, 15)
            .padding(.top, 105)
            .zIndex(1)
            
            VStack {
                ZStack(alignment: .topLeading) {
                    Image("avatar")
                        .resizable()
                        .frame(width: 363, height: 150)
                        .background(Color.yellow)
                        .clipShape(.rect(
                            topLeadingRadius: 20,
                            bottomLeadingRadius: 0,
                            bottomTrailingRadius: 0,
                            topTrailingRadius: 20
                        ))
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 0) {
                        Text(user.name)
                            .lineLimit(1)
                            .foregroundColor(.black)
                            .font(.custom("Montserrat-SemiBold", size: 20))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(width: 194)
                        Spacer()
                        // Toggle button
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                hiddenFullInfo.toggle()
                            }
                        }) {
                            Image(systemName: "chevron.down")
                                .font(.title3)
                                .rotationEffect(.degrees(hiddenFullInfo ? 0 : 180))
                                .foregroundColor(.gray)
                        }
                        .animation(.easeInOut(duration: 0.3), value: hiddenFullInfo)
                        .padding(.trailing, 15)
                    }
                    
                    Text("@" + user.user_name)
                        .lineLimit(1)
                        .foregroundColor(Color.grayProfileTextSM)
                        .font(.custom("Montserrat-Regular", size: 12))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(width: 180)
                        .padding(.leading, 3)
                }
                .padding(.bottom, 15)
                .padding(.top, 5)
                .padding(.leading, 130)
                
                // Full info with animation
                Group {
                    if !hiddenFullInfo {
                        line()
                        info(user: user)
                        line()
                        about(user: user)
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
                .animation(.easeInOut(duration: 0.3), value: hiddenFullInfo)
                
            }
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .frame(width: 363)
    }
    
    @ViewBuilder
    private func line() -> some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.graySM)
            .frame(width: 333, height: 1)
            .padding(.top, 16)
    }
    
    private struct info: View {
        let user: User
        var body: some View {
            VStack {
                HStack(spacing: 3) {
                    Image(systemName: "location")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.grayProfileTextSM)
                    
                    Text(user.location ?? "Earth")
                        .lineLimit(1)
                        .foregroundColor(Color.grayProfileTextSM)
                        .font(.custom("Montserrat-Regular", size: 14))
                        .frame(width: 90, alignment: .leading)
                    
                    Image(systemName: "birthday.cake")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.grayProfileTextSM)
                    
                    Text(parseDateString(user.birthday ?? "") ?? "")
                        .lineLimit(1)
                        .foregroundColor(Color.grayProfileTextSM)
                        .font(.custom("Montserrat-Regular", size: 14))
                        .frame(width: 80)
                }
                .frame(width: 200, height: 20)
                .padding(.leading, 15)
                .padding(.trailing, 141)
                
                HStack(spacing: 3) {
                    Image(systemName: "figure.dress.line.vertical.figure")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.grayProfileTextSM)
                    
                    Text(user.gender != nil ? (user.gender! ? "Мужской" : "Женский") : "Неважно")
                        .lineLimit(1)
                        .foregroundColor(Color.grayProfileTextSM)
                        .font(.custom("Montserrat-Regular", size: 14))
                        .frame(width: 90, alignment: .leading)
                    
                    Image(systemName: "calendar")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.grayProfileTextSM)
                    
                    Text(parseDateString(user.created_at ?? "") ?? "")
                        .lineLimit(1)
                        .foregroundColor(Color.grayProfileTextSM)
                        .font(.custom("Montserrat-Regular", size: 14))
                        .frame(width: 80)
                }
                .frame(width: 200, height: 20)
                .padding(.leading, 15)
                .padding(.trailing, 141)
            }
            .frame(width: 200, height: 20)
            .padding(.top, 15)
            .padding(.leading, 15)
        }
    }
    
    private struct about: View {
        let user: User
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                Text("О себе")
                    .foregroundColor(Color.grayProfileTextSM)
                    .font(.custom("Montserrat-SemiBold", size: 20))
                Text(user.description ?? "")
                    .foregroundColor(Color.grayProfileTextSM)
                    .font(.custom("Montserrat-Regular", size: 14))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(width: 333)
            .padding(.bottom, 15)
        }
    }
}

#Preview {
    OwnDescriptionView(user: User(
        id: 20,
        email: "dasd",
        name: "Danila Shabanov",
        user_name: "danilka",
        description: "DLASMDJNSAJKDNKJSANDdnsakjdnakdnasndaskjdnask ajnsdasndkjandk",
        location: "Voronezh",
        gender: true,
        birthday: "19.01.2004",
        created_at: "20.04.2003"
    ))
}
