//
//  Date+.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 01.05.2025.
//

import Foundation

func parseDateString(_ dateString: String) -> String? {
    let isoFormatter = ISO8601DateFormatter()
    isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    
    guard let date = isoFormatter.date(from: dateString) else {
        return nil
    }
    
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "dd.MM.yyyy"
    outputFormatter.locale = Locale(identifier: "ru_RU")
    
    return outputFormatter.string(from: date)
}
