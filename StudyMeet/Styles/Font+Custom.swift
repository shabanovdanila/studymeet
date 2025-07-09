//
//  Font+Custom.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 09.07.2025.
//
import SwiftUI
extension Font {
    static func montserrat(_ weight: String, size: CGFloat, relativeTo: TextStyle = .body) -> Font {
        .custom("Montserrat-\(weight)", size: size, relativeTo: relativeTo)
    }
    static func montserratAlt(_ weight: String, size: CGFloat, relativeTo: TextStyle = .body) -> Font {
        .custom("MontserratAlternates-\(weight)", size: size, relativeTo: relativeTo)
    }
}
