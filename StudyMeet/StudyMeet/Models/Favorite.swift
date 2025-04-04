//
//  Favorite.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 04.04.2025.
//

import Foundation

struct Favorite: Codable {
    let id: Int
    let user_id: Int
    let announcement_id: Int
}

struct AllFavorite: Codable {
    let favorites: [Favorite]
}
