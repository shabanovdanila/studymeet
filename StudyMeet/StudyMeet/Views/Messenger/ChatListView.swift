//
//  ChatListView.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 04.07.2025.
//
import SwiftUI

struct ChatListView: View {
    @Binding var path: NavigationPath
    @Binding var currentScreen: CurrentScreen
    
    @StateObject private var viewModel = ChatListViewModel()
    @EnvironmentObject private var userSession: UserSession
    
    var body: some View {
        List {
            ForEach(viewModel.chats, id: \.id) { chat in
                Button {
                    path.append(PathNavigator.chatDetail(chatId: chat.id))
                    currentScreen = .chatDetail
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(chat.name)
                                .font(.headline)
                            
                            Text(chat.last_message.content)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                        Spacer()
                        Text(timeFormatted(chat.last_message.created_at))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 4)
                }
            }
            
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                Button("Загрузить ещё") {
                    viewModel.loadNextPage()
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundColor(.blue)
            }
        }
        .navigationTitle("Чаты")
        .onAppear {
            Task { await viewModel.refreshChats() }
        }
        .alert("Ошибка", isPresented: Binding<Bool>(
            get: { viewModel.error != nil },
            set: { _ in viewModel.error = nil }
        )) {
            Button("Ок", role: .cancel) {}
        } message: {
            Text(viewModel.error?.localizedDescription ?? "")
        }
    }
    
    func timeFormatted(_ isoString: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: isoString) {
            let outFormatter = DateFormatter()
            outFormatter.dateFormat = "HH:mm"
            return outFormatter.string(from: date)
        }
        return ""
    }
}
