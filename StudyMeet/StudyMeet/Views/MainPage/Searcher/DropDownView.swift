//
//  DropDownView.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 16.04.2025.
//

import SwiftUI

struct DropDownView: View {
    
    var options: [String]
    var hint: String
    
    @Binding var selection: String?
    @State private var showOption: Bool = false
    
    @SceneStorage("drop_down_zindex") private var index = 1000.0
    @State private var zIndex: Double = 1000.0
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text(selection ?? hint)
                        .foregroundStyle(selection == nil ? .gray : .primary)
                        .lineLimit(1)
                    
                    Spacer(minLength: 0)
                    
                    Image(systemName: "chevron.down")
                        .font(.title3)
                        .foregroundStyle(.gray)
                        .rotationEffect(.init(degrees: showOption ? -180: 0))
                }
                .padding(.horizontal, 15)
                .frame(width: size.width, height: size.height)
                .contentShape(.rect)
                .onTapGesture {
                    index += 1
                    zIndex = index
                    withAnimation(.snappy) {
                        showOption.toggle()
                    }
                }
                .zIndex(1)
                
                if showOption {
                    OptionsView()
                }
                    
            }
            .clipped()
            .contentShape(.rect)
            .background(.white.shadow(.drop(color: .primary.opacity(0.15), radius: 4)), in :.rect(cornerRadius: 20))
        }
        .frame(width: 160, height: 50)
        .zIndex(zIndex)
    }
    
    @ViewBuilder
    func OptionsView() -> some View {
        VStack(spacing: 10) {
            ForEach(options, id: \.self) {option in
                HStack(spacing: 0) {
                    Text(option)
                        .lineLimit(1)
                    Spacer(minLength: 0)
                    Image(systemName: "checkmark")
                        .font(.caption)
                        .opacity(selection == option ? 1 : 0)
                }
                .foregroundStyle(selection == option ? Color.primary : Color.gray)
                .animation(.none, value: selection)
                .frame(height: 40)
                .contentShape(.rect)
                .onTapGesture {
                    withAnimation(.snappy) {
                        selection = option
                        showOption = false
                    }
                }
            }
        }
        .padding(.horizontal, 15)
    }
}

