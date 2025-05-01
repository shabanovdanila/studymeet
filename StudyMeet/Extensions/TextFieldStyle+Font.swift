//
//  TextFieldStyle+Font.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 22.04.2025.
//

import SwiftUI

extension View {
    func registrationTextFieldStyle() -> some View {
        self
            .font(.custom("Montserrat-Regular", size: 14))
            .padding(.horizontal, 15)
            .padding(.top, 11)
            .padding(.bottom, 12)
            .foregroundColor(Color(r: 122, g: 122, b: 122))
            .contrast(0)
    }
}
