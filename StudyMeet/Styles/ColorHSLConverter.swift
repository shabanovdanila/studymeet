//
//  ColorHSLConverter.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 11.05.2025.
//

import SwiftUI

struct ColorHSLConverter {
    static func getHslColor(colorhsl: String) -> Color {
        let trimmedString = colorhsl.replacingOccurrences(of: "hsl(", with: "").replacingOccurrences(of: ")", with: "")

        let components = trimmedString.components(separatedBy: ", ")
        
        if components.count == 3 {
            let hue = Double(components[0])!
            let saturation = Double(components[1].replacingOccurrences(of: "%", with: ""))!
            let lightness = Double(components[2].replacingOccurrences(of: "%", with: ""))!
            return Color(hue: hue, saturation: (saturation / 100), lightness: (lightness / 100))
        }
        return Color(r: 0, g: 0, b: 0)
    }
}
