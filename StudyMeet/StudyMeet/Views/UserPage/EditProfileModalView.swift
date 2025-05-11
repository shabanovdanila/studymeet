//
//  EditProfileModalView.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 10.05.2025.
//

import SwiftUI

struct EditProfileModalView: View {
    
    //@EnvironmentObject private var userSession: UserSession
    
    @State var text: String = "Emilia Lin"
    
    @State private var bio: String = "Привет! Я Анна, и я увлечена изучением новых технологий и программирования. В данный момент я занимаюсь разработкой проектов в области искусственного интеллекта и ищу напарника для совместного изучения и обмена знаниями."
    
    
    var body: some View {
            
        VStack(alignment: .center, spacing: 0) {
            
            HStack(spacing: 0) {
                Text("Редактировать профиль")
                    .foregroundColor(.black)
                    .font(.custom("Montserrat-SemiBold", size: 18))
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .offset(x: 25)
                
            }
            
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(.cyan)
                    .frame(width: 333, height: 125)
                avatar(size: 100)
                    .padding(.top, 75)
                    .padding(.horizontal, 15)
                Image(systemName: "pencil")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding([.leading, .top], 10)
                Image(systemName: "trash")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding(.top, 10)
                    .padding(.leading, 299)
                TextField("Emilia lin", text: $text)
                    .font(.custom("Montserrat-Regular", size: 14))
                    .padding([.top, .bottom], 10)
                    .padding(.horizontal, 15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color(red: 235/255, green: 235/255, blue: 235/255), lineWidth: 1)
                    )
                    .frame(width: 208, height: 30)
                    .padding(.top, 140)
                    .padding(.leading, 125)
            }
            .padding(.top, 16)
              
            line()
                .padding(15)
            
            VStack(spacing: 0) {
                HStack(spacing: 13) {
                    TextField("Emilia lin", text: $text)
                        .font(.custom("Montserrat-Regular", size: 14))
                        .padding([.top, .bottom], 10)
                        .padding(.horizontal, 15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color(red: 235/255, green: 235/255, blue: 235/255), lineWidth: 1)
                        )
                        .frame(width: 160, height: 30)
                    
                    TextField("Emilia lin", text: $text)
                        .font(.custom("Montserrat-Regular", size: 14))
                        .padding([.top, .bottom], 10)
                        .padding(.horizontal, 15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color(red: 235/255, green: 235/255, blue: 235/255), lineWidth: 1)
                        )
                        .frame(width: 160, height: 30)
                }
                
                HStack(spacing: 13) {
                    TextField("Emilia lin", text: $text)
                        .font(.custom("Montserrat-Regular", size: 14))
                        .padding([.top, .bottom], 10)
                        .padding(.horizontal, 15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color(red: 235/255, green: 235/255, blue: 235/255), lineWidth: 1)
                        )
                        .frame(width: 160, height: 30)
                    
                    TextField("Emilia lin", text: $text)
                        .font(.custom("Montserrat-Regular", size: 14))
                        .padding([.top, .bottom], 10)
                        .padding(.horizontal, 15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color(red: 235/255, green: 235/255, blue: 235/255), lineWidth: 1)
                        )
                        .frame(width: 160, height: 30)
                }
                .padding(.top, 20)
                
                line()
                    .padding(15)
                TextEditor(text: $bio)
                    .font(.custom("Montserrat-Regular", size: 14))
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color(red: 235/255, green: 235/255, blue: 235/255), lineWidth: 1)
                    )
                    .frame(width: 333, height: 170)
            }
            
        }
        .frame(width: 363, height: 579)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(red: 235/255, green: 235/255, blue: 235/255), lineWidth: 1)
        )
    }
    
    @ViewBuilder
    private func line() -> some View {
        RoundedRectangle(cornerRadius: 10)
                .fill(Color(red: 235 / 255, green: 235 / 255, blue: 235 / 255))
                .frame(width: 333, height: 1, alignment: .center)
    }
    
    private struct avatar: View {
        var size: CGFloat
        //var avatarPicture:
        
        var body: some View {
            ZStack {
                Circle()
                    .foregroundStyle(Color.white)
                    .frame(width: size, height: size)
                
                Image(systemName: "cat.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(10)
                    .frame(width: size - 5, height: size - 5)
                    .background(Color.yellow)
                    .clipShape(Circle())
            }
        }
    }
}

#Preview {
    EditProfileModalView()
}
