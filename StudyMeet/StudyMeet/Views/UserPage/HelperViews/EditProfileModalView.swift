//
//  EditProfileModalView.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 10.05.2025.
//
import SwiftUI

struct EditProfileModalView: View {
    @StateObject var viewModel: EditProfileViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            // Заголовок и кнопка закрытия
            HStack(spacing: 0) {
                Text("Редактировать профиль")
                    .foregroundColor(.black)
                    .font(.custom("Montserrat-SemiBold", size: 18))
                
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                .offset(x: 25)
            }
            
            // Аватар и основные поля
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(.cyan)
                    .frame(width: 333, height: 125)
                
                avatar(size: 100)
                    .padding(.top, 75)
                    .padding(.horizontal, 15)
                
                // Кнопки редактирования/удаления аватара
                Button(action: { /* Выбор нового фото */ }) {
                    Image(systemName: "pencil")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                .padding([.leading, .top], 10)
                
                Button(action: { Task { await viewModel.deleteProfileImage() } }) {
                    Image(systemName: "trash")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                .padding(.top, 10)
                .padding(.leading, 299)
                
                TextField("Имя", text: $viewModel.name)
                    .foregroundStyle(Color.gray)
                    .font(.custom("Montserrat-Regular", size: 14))
                    .padding([.top, .bottom], 10)
                    .padding(.horizontal, 15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.graySM, lineWidth: 1)
                    )
                    .frame(width: 208, height: 30)
                    .padding(.top, 140)
                    .padding(.leading, 125)
            }
            .padding(.top, 16)
              
            line()
                .padding(15)
            
            // Основные поля формы
            VStack(spacing: 0) {
                // Город и дата рождения
                HStack(spacing: 13) {
                    TextField("Город", text: $viewModel.location)
                        .foregroundStyle(Color.gray)
                        .font(.custom("Montserrat-Regular", size: 14))
                        .padding([.top, .bottom], 10)
                        .padding(.horizontal, 15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.graySM, lineWidth: 1)
                        )
                        .frame(width: 160, height: 30)
                    
                    TextField("21.01.2001", text: $viewModel.birthday)
                        .foregroundStyle(Color.gray)
                        .font(.custom("Montserrat-Regular", size: 14))
                        .padding([.top, .bottom], 10)
                        .padding(.horizontal, 15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.graySM, lineWidth: 1)
                        )
                        .frame(width: 160, height: 30)
                }
                
                // Пол и фамилия
                HStack(spacing: 13) {
                    
                    Menu {
                        Picker(selection: $viewModel.gender, label: EmptyView()) {
                            Text("Мужской").tag(true)
                            Text("Женский").tag(false)
                            Text("Не указано").tag(nil as Bool?)
                        }
                        
                    } label: {
                        HStack {
                            Text(genderToString(gender: viewModel.gender))
                            Spacer()
                            Image(systemName: "chevron.down")
                        }
                        .foregroundStyle(Color.gray)
                        .font(.custom("Montserrat-Regular", size: 14))
                        .padding([.top, .bottom], 10)
                        .padding(.horizontal, 15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.graySM, lineWidth: 1)
                        )
                        .frame(width: 160, height: 30)
                    }
                    HStack(spacing: 0) {
                        Text(viewModel.created_at)
                        Spacer()
                    }
                        .font(.custom("Montserrat-Regular", size: 14))
                        .foregroundStyle(Color.gray)
                        .padding([.top, .bottom], 10)
                        .padding(.horizontal, 15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.graySM, lineWidth: 1)
                        )
                        .frame(width: 160, height: 30)
                }
                .padding(.top, 20)
                
                line()
                    .padding(15)
                
                // Биография
                TextEditor(text: $viewModel.description)
                    .font(.custom("Montserrat-Regular", size: 14))
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.graySM, lineWidth: 1)
                    )
                    .frame(width: 333, height: 170)
                
                // Кнопки сохранения/отмены
                HStack {
                    Button("Отменить") {
                        dismiss()
                    }
                    .frame(width: 150, height: 44)
                    .background(Color.graySM)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    Button("Сохранить") {
                        Task {
                            await viewModel.updateProfile()
                            if viewModel.updateSuccess {
                                dismiss()
                            }
                        }
                    }
                    .frame(width: 150, height: 44)
                    .background(Color.lightBlueSM)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .padding(.top, 20)
            }
        }
        .frame(width: 363, height: 579)
        .alert("Уведомление", isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage)
        }
    }
    
        @ViewBuilder
        private func line() -> some View {
            RoundedRectangle(cornerRadius: 10)
                    .fill(Color.graySM)
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
    //TODO вынести отсюда 
    private func genderToString(gender: Bool?) -> String {
        print(viewModel.created_at)
        return gender == true ? "Мужской" : gender == false ? "Женский" : "Не указано"
    }
}



#Preview {
    EditProfileModalView(viewModel: EditProfileViewModel())
}





//import SwiftUI
//
//struct EditProfileModalView: View {
//    @State var text: String = ""
//    @State private var bio: String = ""
//    
//    var body: some View {
//            
//        VStack(alignment: .center, spacing: 0) {
//            
//            HStack(spacing: 0) {
//                Text("Редактировать профиль")
//                    .foregroundColor(.black)
//                    .font(.custom("Montserrat-SemiBold", size: 18))
//                Image(systemName: "xmark")
//                    .resizable()
//                    .frame(width: 20, height: 20)
//                    .offset(x: 25)
//                
//            }
//            
//            ZStack(alignment: .topLeading) {
//                RoundedRectangle(cornerRadius: 15)
//                    .foregroundColor(.cyan)
//                    .frame(width: 333, height: 125)
//                avatar(size: 100)
//                    .padding(.top, 75)
//                    .padding(.horizontal, 15)
//                Image(systemName: "pencil")
//                    .resizable()
//                    .frame(width: 24, height: 24)
//                    .padding([.leading, .top], 10)
//                Image(systemName: "trash")
//                    .resizable()
//                    .frame(width: 24, height: 24)
//                    .padding(.top, 10)
//                    .padding(.leading, 299)
//                TextField("Emilia lin", text: $text)
//                    .font(.custom("Montserrat-Regular", size: 14))
//                    .padding([.top, .bottom], 10)
//                    .padding(.horizontal, 15)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 30)
//                            .stroke(Color.graySM, lineWidth: 1)
//                    )
//                    .frame(width: 208, height: 30)
//                    .padding(.top, 140)
//                    .padding(.leading, 125)
//            }
//            .padding(.top, 16)
//              
//            line()
//                .padding(15)
//            
//            VStack(spacing: 0) {
//                HStack(spacing: 13) {
//                    TextField("Emilia lin", text: $text)
//                        .font(.custom("Montserrat-Regular", size: 14))
//                        .padding([.top, .bottom], 10)
//                        .padding(.horizontal, 15)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 30)
//                                .stroke(Color.graySM, lineWidth: 1)
//                        )
//                        .frame(width: 160, height: 30)
//                    
//                    TextField("Emilia lin", text: $text)
//                        .font(.custom("Montserrat-Regular", size: 14))
//                        .padding([.top, .bottom], 10)
//                        .padding(.horizontal, 15)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 30)
//                                .stroke(Color.graySM, lineWidth: 1)
//                        )
//                        .frame(width: 160, height: 30)
//                }
//                
//                HStack(spacing: 13) {
//                    TextField("Emilia lin", text: $text)
//                        .font(.custom("Montserrat-Regular", size: 14))
//                        .padding([.top, .bottom], 10)
//                        .padding(.horizontal, 15)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 30)
//                                .stroke(Color.graySM, lineWidth: 1)
//                        )
//                        .frame(width: 160, height: 30)
//                    
//                    TextField("Emilia lin", text: $text)
//                        .font(.custom("Montserrat-Regular", size: 14))
//                        .padding([.top, .bottom], 10)
//                        .padding(.horizontal, 15)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 30)
//                                .stroke(Color.graySM, lineWidth: 1)
//                        )
//                        .frame(width: 160, height: 30)
//                }
//                .padding(.top, 20)
//                
//                line()
//                    .padding(15)
//                TextEditor(text: $bio)
//                    .font(.custom("Montserrat-Regular", size: 14))
//                    .padding(10)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 15)
//                            .stroke(Color.graySM, lineWidth: 1)
//                    )
//                    .frame(width: 333, height: 170)
//            }
//            
//        }
//        .frame(width: 363, height: 579)
//        .overlay(
//            RoundedRectangle(cornerRadius: 20)
//                .stroke(Color.graySM, lineWidth: 1)
//        )
//        
//    }
//    
//    @ViewBuilder
//    private func line() -> some View {
//        RoundedRectangle(cornerRadius: 10)
//                .fill(Color.graySM)
//                .frame(width: 333, height: 1, alignment: .center)
//    }
//    
//    private struct avatar: View {
//        var size: CGFloat
//        //var avatarPicture:
//        
//        var body: some View {
//            ZStack {
//                Circle()
//                    .foregroundStyle(Color.white)
//                    .frame(width: size, height: size)
//                
//                Image(systemName: "cat.fill")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .padding(10)
//                    .frame(width: size - 5, height: size - 5)
//                    .background(Color.yellow)
//                    .clipShape(Circle())
//            }
//        }
//    }
//}
//
//#Preview {
//    EditProfileModalView()
//}
