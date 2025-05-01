//
//  Color+HSL.swift
//  StudyMate
//
//  Created by Данила Шабанов on 30.03.2025.
//

import SwiftUI

extension Color {
    init(hue: Double, saturation: Double, lightness: Double) {
        let c = (1 - abs(2 * lightness - 1)) * saturation
        let x = c * (1 - abs((hue / 60).truncatingRemainder(dividingBy: 2) - 1))
        let m = lightness - c / 2

        var r: Double = 0
        var g: Double = 0
        var b: Double = 0

        switch hue {
        case 0..<60:
            r = c
            g = x
        case 60..<120:
            r = x
            g = c
        case 120..<180:
            g = c
            b = x
        case 180..<240:
            g = x
            b = c
        case 240..<300:
            r = x
            b = c
        case 300..<360:
            r = c
            b = x
        default:
            break
        }

        r += m
        g += m
        b += m

        self.init(red: r, green: g, blue: b)
    }
}
