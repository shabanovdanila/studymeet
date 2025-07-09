//
//  ChatClient.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 04.07.2025.
//

import Foundation
import SocketIO

struct CreateMessageRequest: Codable {
    let chat_id: Int
    let answered_message_id: Int?
    let content: String
}

final class ChatSocketService {
    static let shared = ChatSocketService()

    private var manager: SocketManager!
    private var socket: SocketIOClient!
    
    private init() {}

    func connect(token: String?) {
        guard let token else {return }
        guard let url = URL(string: "http://194.87.207.73:8081") else {
            print("❌ Invalid socket URL")
            return
        }

        let config: SocketIOClientConfiguration = [
                    .log(true),  // Включить логирование
                    .compress,  // Включить сжатие
                    .forceWebsockets(true),  // Принудительно использовать WebSockets
                    .forceNew(true),  // Создавать новое соединение каждый раз
                    .connectParams(["token": token]),  // Параметры подключения
                    .extraHeaders(["Sec-WebSocket-Protocol": "ios"]),  // Дополнительные заголовки
                    .version(.two)
                ]

        manager = SocketManager(socketURL: url, config: config)
        socket = manager.defaultSocket

        socket.on(clientEvent: .connect) { data, _ in
            print("✅ Socket connected")
        }

        socket.on(clientEvent: .error) { data, _ in
            print("❌ Socket error: \(data)")
        }

        socket.on(clientEvent: .disconnect) { _, _ in
            print("⚠️ Socket disconnected")
        }

//        socket.on("new_message") { data, _ in
//            guard let dict = data.first as? [String: Any],
//                  let jsonData = try? JSONSerialization.data(withJSONObject: dict),
//                  let message = try? JSONDecoder().decode(ChatMessage.self, from: jsonData) else {
//                print("⚠️ Failed to parse new_message")
//                return
//            }
//            NotificationCenter.default.post(name: .newMessageReceived, object: message)
//        }
        socket.on("new_message") { data, _ in
            guard let dict = data.first as? [String: Any],
                  let id = dict["id"] as? Int,
                  let content = dict["content"] as? String,
                  let userId = dict["user_id"] as? Int,
                  let chatId = dict["chat_id"] as? Int else {
                print("⚠️ Missing required fields in message")
                return
            }
            
            let username = dict["username"] as? String ?? "Unknown"
            let createdAt = dict["created_at"] as? String ?? ""
            
            let message = ChatMessage(
                id: id,
                content: content,
                user_id: userId,
                username: username,
                chat_id: chatId,
                answered_message: nil, created_at: createdAt,
                updated_at: nil,
                deleted_at: nil
            )
            
            NotificationCenter.default.post(name: .newMessageReceived, object: message)
        }
        socket.connect()
    }

    func disconnect() {
        socket?.disconnect()
    }

    func sendMessage(_ message: CreateMessageRequest) {
        let payload: [String: Any] = [
            "chat_id": message.chat_id,
            "content": message.content,
            "answered_message_id": message.answered_message_id as Any
        ]

        socket.emit("new_message", payload)
        print("SEND SEND SEND")
    }
}

extension Notification.Name {
    static let newMessageReceived = Notification.Name("newMessageReceived")
}
