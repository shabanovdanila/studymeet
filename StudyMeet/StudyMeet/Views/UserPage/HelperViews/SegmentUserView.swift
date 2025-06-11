//
//  SegmentUserView.swift
//  StudyMate
//
//  Created by Данила Шабанов on 19.03.2025.
//

import SwiftUI

struct SegmentUserView: View {

    // MARK: - Properties

    @Binding var selection: Option
    let options = [Option.first, Option.second]

    // MARK: - UI

    var body: some View {
        HStack {
            ForEach(options, id: \.self) { option in
                Segment(
                    title: option.rawValue,
                    isSelected: selection == option,
                    action: { selection = option},
                    icon: option.icon
                )
                .frame(width: 176, height: 40, alignment: .center)
            }
        }
        .frame(width: 363, height: 46)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }
}

private struct Segment: View {
    
    // MARK: - Properties
    
    let title: String
    let isSelected: Bool
    let action: () -> Void
    let icon: Image
    
    @State private var isPressed: Bool = false
    
    // MARK: - UI
    
    var body: some View {
        Button(action: action) {
            HStack() {
                icon
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                Text(title)
                    .font(.custom("Montserrat-Medium", size: 16))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .foregroundColor((isSelected ? Color.white : Color.darkBlueSM))
            .background {
                if isSelected {
                    Color.white
                    Color.lightBlueSM
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            }
            .animation(.default, value: isPressed)
        }
    }
    
}

enum Option: String, Identifiable, CaseIterable {
    case first = "Объявления"
    //TODO
    case second = "Избранное  "

    var icon: Image {
        switch self {
        case .first: return Image(systemName: "tray")
        case .second: return Image(systemName: "heart.circle")
        }
    }
    
    var id: String {rawValue}
}
