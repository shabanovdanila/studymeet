//
//  DependencyContainer.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 11.05.2025.
//

import Foundation

final class DependencyContainer {
    
    
    static let shared = DependencyContainer()

    private let baseURL: String
    private let sharedRequestHandler: RequestHandler

    private init() {
        self.baseURL = "http://194.87.207.73/api"
        let apiPerformer = ApiPerformerDefault(baseURL: baseURL)
        self.sharedRequestHandler = RequestHandlerDefault(apiPerformer: apiPerformer)
    }

    // MARK: - Clients
    func makeAnnounceClient() -> AnnounceClient {
        AnnounceClient(requestHandler: sharedRequestHandler)
    }

    func makeUserClient() -> UserClient {
        UserClient(requestHandler: sharedRequestHandler)
    }
    
    func makeAuthClient() -> AuthClient {
        AuthClient(requestHandler: sharedRequestHandler)
    }
    
    func makeFavoriteClient() -> FavoriteClient {
        FavoriteClient(requestHandler: sharedRequestHandler)
    }

    func makeResponseClient() -> ResponseClient {
        ResponseClient(requestHandler: sharedRequestHandler)
    }
    
    func makeTagClient() -> TagClient {
        TagClient(requestHandler: sharedRequestHandler)
    }
    
    func makeChatClient() -> ChatClient {
        ChatClient(requestHandler: sharedRequestHandler)
    }
}
