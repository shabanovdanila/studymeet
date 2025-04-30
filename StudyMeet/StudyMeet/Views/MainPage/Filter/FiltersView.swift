//
//  FiltersView.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 11.04.2025.
//

import SwiftUI

struct FiltersView: View {
    let colors = ["Red", "Green", "Black"]
    @State private var selection: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Фильтры")
                    .foregroundColor(.black)
                    .font(.custom("Montserrat-SemiBold", size: 18))

                Spacer()
                
                Image(systemName: "xmark")
                    .resizable()
                    .foregroundColor(.black)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
            }
            .padding([.top, .trailing, .horizontal], 20)
            Text("Город")
                .foregroundColor(.black)
                .font(.custom("Montserrat-Medium", size: 16))
                .padding(.horizontal, 20)
                .padding(.top, 10)
            DropDownView(options: ["Воронеж", "Воронежzcss", "Воронеж1", "Вороне2ж", "Ворон3ежkkkkkkkkkk", "Во4ронеж", "Вор4о1неж", "5Воронеж", "Ворон2еж", "Воро3неж", "Воронежfk"], hint: "Выберите город", selection: $selection)
        }
    }
}
