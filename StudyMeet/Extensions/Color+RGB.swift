//
//  Color+RGB.swift
//  StudyMate
//
//  Created by Данила Шабанов on 30.03.2025.
//

import SwiftUI

extension Color {
    init(r: Double, g: Double, b: Double) {
        self.init(red: r / 255, green: g / 255, blue: b / 255)
    }
}
