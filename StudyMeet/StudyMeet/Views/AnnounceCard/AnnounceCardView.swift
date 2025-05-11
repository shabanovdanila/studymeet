//
//  AdCardView.swift
//  StudyMate
//
//  Created by Данила Шабанов on 24.02.2025.
//

import SwiftUI

struct AnnounceCardView: View {
    //
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
                    Text(announce.name)
                        .lineLimit(1)
                        .foregroundColor(.black)
                        .font(.custom("Montserrat-Regular", size: 14))
                }
                .padding(.leading, 15)
                .padding(.bottom, 4)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(width: 363, height: 89)
            .background(ColorHSLConverter.getHslColor(colorhsl: announce.bg_color ?? ""))
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
                    if (!(announce.tags).isEmpty) {
                        ForEach(announce.tags) {tag in
                            Text("#" + (tag.name ?? ""))
                                .foregroundColor(Color.black)
                                .font(.custom("Montserrat-Regular", size: 10))
                                .padding([.top, .bottom], 3)
                                .padding([.trailing, .leading], 6)
                                .background(ColorHSLConverter.getHslColor(colorhsl: tag.color ?? ""))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    } else {
                        Text("#")
                            .foregroundColor(Color.black)
                            .font(.custom("Montserrat-Regular", size: 10))
                            .padding([.top, .bottom], 3)
                            .padding([.trailing, .leading], 6)
                            .background(Color(r: 255, g: 139, b: 139))
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


