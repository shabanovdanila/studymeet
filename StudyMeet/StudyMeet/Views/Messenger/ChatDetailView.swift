//
//  ChatDetailView.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 05.07.2025.
//

import SwiftUI

struct ChatDetailView: View {
    let chatId: Int
    @StateObject private var viewModel: ChatDetailViewModel

    init(chatId: Int) {
        self.chatId = chatId
        _viewModel = StateObject(wrappedValue: ChatDetailViewModel(chatId: chatId))
    }

    var body: some View {
        VStack {
            ScrollViewReader { scrollView in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(viewModel.messages, id: \.id) { message in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(message.username)
                                    .font(.caption)
                                    .foregroundColor(.blue)
                                Text(message.content)
                                    .font(.body)
                                    .padding(8)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                            }
                            .id(message.id)
                        }
                    }
                    .padding()
                    .rotationEffect(.degrees(180)) // переворачиваем сообщения
                }
                .rotationEffect(.degrees(180)) // переворачиваем скролл
                .onChange(of: viewModel.messages.count) { _ in
                    if let last = viewModel.messages.last {
                        withAnimation {
                            scrollView.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
            }

            Divider()

            HStack {
                TextField("Сообщение...", text: $viewModel.messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Отправить") {
                    viewModel.sendMessage()
                }
                .disabled(viewModel.messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .navigationTitle("Чат #\(chatId)")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.onAppear()
        }
    }
}
