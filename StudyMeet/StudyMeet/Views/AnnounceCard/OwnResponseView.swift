//
//  ResponseView.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 20.05.2025.
//

import SwiftUI

struct OwnResponseView: View {

    @State var user_name: String
    @State var description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Text(user_name)
                Spacer()
                Image(systemName: "xmark")
                    .foregroundColor(.red)
                    .padding()
                Image(systemName: "checkmark")
                    .foregroundColor(.green)
                    .padding()
            }
            .padding()
            Text(description)
                .padding()
        }
        .foregroundColor(.black)
        .font(.custom("Montserrat-SemiBold", size: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(red: 235/255, green: 235/255, blue: 235/255), lineWidth: 1)
        )
    }
}

