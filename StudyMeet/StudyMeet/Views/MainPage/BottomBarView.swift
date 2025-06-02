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
                    .foregroundColor(Color.darkBlueSM)
                    .frame(width: 30, height: 30)
                
                if page1 { RoundedRectangle(cornerRadius: 10)
                    
                    //tODO
                        .fill(Color.blueLineSM)
                        .frame(width: 20, height: 2, alignment: .center)
                        .padding(.top, 47)
                }
            }
            .padding(.leading, 41)
            .padding(.top, 15)
            ZStack(alignment: .center) {
                Image(systemName: "ellipsis.message")
                    .resizable()
                    .foregroundColor(Color.darkBlueSM)
                    .frame(width: 30, height: 30)
                if !page1 { RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blueLineSM)
                        .frame(width: 20, height: 2, alignment: .center)
                        .padding(.top, 47)
                }
            }
            .padding(.leading, 112.5)
            .padding(.top, 15)
            ZStack(alignment: .center) {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .foregroundColor(Color.darkBlueSM)
                    .frame(width: 30, height: 30)
                if !page1 { RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blueLineSM)
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
