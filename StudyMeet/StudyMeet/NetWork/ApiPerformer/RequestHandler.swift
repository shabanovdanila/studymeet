//
//  RequestHandlerProtocol.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 20.04.2025.
//

import Foundation

protocol RequestHandler {
    
    func get<T: Decodable>(path: String?, query: [String: String?]?, headers: [String: String]?) async throws -> T
    
    func post<T: Decodable>(path: String?, body: Encodable?, query: [String: String?]?, headers: [String: String]?) async throws -> T
    
    func post(path: String?, body: Encodable?, query: [String: String?]?, headers: [String: String]?) async throws
    
    func put<T: Decodable>(path: String?, body: Encodable?, query: [String: String?]?, headers: [String: String]?) async throws -> T
    
    func put(path: String?, body: Encodable?, query: [String: String?]?, headers: [String: String]?) async throws
    
    func delete<T: Decodable>(path: String?, body: Encodable?, query: [String: String?]?, headers: [String: String]?) async throws -> T
    
    func delete(path: String?, body: Encodable?, query: [String: String?]?, headers: [String: String]?) async throws
}
