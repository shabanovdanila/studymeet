//
//  Tag.swift
//  StudyMate
//
//  Created by Данила Шабанов on 25.03.2025.
//

import Foundation

struct Tag: Codable, Identifiable {
    let id: Int?
    let name: String?
    let color: String?
}
//"hsl(350, 98%, 79%)"

struct AllTag: Codable {
    let tags: [Tag]
}
