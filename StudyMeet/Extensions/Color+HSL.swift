//
//  Color+HSL.swift
//  StudyMate
//
//  Created by Данила Шабанов on 30.03.2025.
//

import SwiftUI

import SwiftUI

extension Color {
    init(hue h: Double, saturation s: Double, lightness l: Double) {
        let h = h / 360.0
        let q = l < 0.5 ? l * (1 + s) : l + s - l * s
        let p = 2 * l - q
        
        func hueToRGB(_ t: Double) -> Double {
            let t = t < 0 ? t + 1 : (t > 1 ? t - 1 : t)
            if t < 1/6 { return p + (q - p) * 6 * t }
            if t < 1/2 { return q }
            if t < 2/3 { return p + (q - p) * (2/3 - t) * 6 }
            return p
        }
        
        let r = hueToRGB(h + 1/3)
        let g = hueToRGB(h)
        let b = hueToRGB(h - 1/3)
        
        self.init(red: r, green: g, blue: b)
    }
}
