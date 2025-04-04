//
//  AdCardView.swift
//  StudyMate
//
//  Created by Данила Шабанов on 24.02.2025.
//

import SwiftUI

struct AnnounceCardView: View {
    let announce: Announcement
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text(announce.title)
                    .lineLimit(2)
                    .foregroundColor(.black)
                    .font(.custom("Montserrat-SemiBold", size: 16))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading, .trailing, .top], 15)
                HStack {
                    Image(systemName: "cat.fill")
                        .resizable()
                        .padding(3)
                        .frame(width: 20, height: 20)
                        .background(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                        .clipShape(Circle())
                    Text(announce.user_name)
                        .foregroundColor(.black)
                        .font(.custom("Montserrat-Regular", size: 14))
                }
                .padding(.leading, 15)
                .padding(.bottom, 4)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(width: 363, height: 89)
            .background(Color.purple)
            .clipShape(.rect(
                topLeadingRadius: 20,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 20,
                topTrailingRadius: 20
            ))
            
            VStack(alignment: .leading) {
                Text("Теги")
                    .foregroundColor(Color(red: 122 / 255, green: 122 / 255, blue: 122 / 255))
                    .font(.custom("Montserrat-Regular", size: 10))
                HStack {
                    ForEach(announce.tags) {tag in
                        Text(tag.name ?? "")
                            .foregroundColor(Color.black)
                            .font(.custom("Montserrat-Regular", size: 10))
                            .padding([.top, .bottom], 3)
                            .padding([.trailing, .leading], 6)
                            .background(tag.colorHSL)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.trailing, .leading], 15)
            .padding(.top, 5)
            .padding(.bottom, 27)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(width: 363, height: 150)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 1)
    }
}

private extension Tag {
    var colorHSL: Color {
        if let colorhsl = color {
            let trimmedString = colorhsl.replacingOccurrences(of: "hsl(", with: "").replacingOccurrences(of: ")", with: "")
            
            let components = trimmedString.components(separatedBy: ",")
            
            if components.count == 3,
               let hue = Double(components[0]),
               let saturation = Double(components[1].replacingOccurrences(of: "%", with: "")),
               let lightness = Double(components[2].replacingOccurrences(of: "%", with: "")) {
                
                return Color(hue: hue, saturation: saturation, lightness: lightness)
            }
        }
        return Color(r: 0, g: 0, b: 0)
    }
}
