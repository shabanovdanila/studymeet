//
//  UIAppliation.swift
//  StudyMate
//
//  Created by Данила Шабанов on 24.03.2025.
//

import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
