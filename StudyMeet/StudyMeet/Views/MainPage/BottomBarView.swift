//
//  BottomBarView.swift
//  StudyMate
//
//  Created by Данила Шабанов on 24.02.2025.
//

import SwiftUI

struct BottomBarView: View {
    @State var page1: Bool
    var body: some View {
        HStack() {
            ZStack(alignment: .center) {
                Image(systemName: "house")
                    .resizable()
                    .foregroundColor(Color(red: 30 / 255, green: 58 / 255, blue: 138 / 255))
                    .frame(width: 30, height: 30)
                
                if page1 { RoundedRectangle(cornerRadius: 10)
                        .fill(Color(red: 0 / 255, green: 117 / 255, blue: 255 / 255))
                        .frame(width: 20, height: 2, alignment: .center)
                        .padding(.top, 47)
                }
            }
            .padding(.leading, 41)
            .padding(.top, 15)
            ZStack(alignment: .center) {
                Image(systemName: "ellipsis.message")
                    .resizable()
                    .foregroundColor(Color(red: 30 / 255, green: 58 / 255, blue: 138 / 255))
                    .frame(width: 30, height: 30)
                if !page1 { RoundedRectangle(cornerRadius: 10)
                        .fill(Color(red: 0 / 255, green: 117 / 255, blue: 255 / 255))
                        .frame(width: 20, height: 2, alignment: .center)
                        .padding(.top, 47)
                }
            }
            .padding(.leading, 112.5)
            .padding(.top, 15)
            ZStack(alignment: .center) {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .foregroundColor(Color(red: 30 / 255, green: 58 / 255, blue: 138 / 255))
                    .frame(width: 30, height: 30)
                if !page1 { RoundedRectangle(cornerRadius: 10)
                        .fill(Color(red: 0 / 255, green: 117 / 255, blue: 255 / 255))
                        .frame(width: 20, height: 2, alignment: .center)
                        .padding(.top, 47)
                }
            }
            .padding(.leading, 113.75)
            .padding(.trailing, 42)
            .padding(.top, 15)
        }
        .background(Color.white)
        .frame(width: 393, height: 50)
    }
}
