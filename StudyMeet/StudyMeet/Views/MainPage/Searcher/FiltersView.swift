//
//  FiltersView.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 11.04.2025.
//

import SwiftUI

import SwiftUI

struct FiltersView: View {
    @State private var selectedCity: String = "Не выбрано"
    @State private var showCityPicker = false
    
    @State private var selectedGender: String = "Любой"
    @State private var minAge: Double = 14
    @State private var maxAge: Double = 85
    
    @StateObject private var rangeSliderVM = RangeSliderView.ViewModel(
        sliderPosition: 14...85,
        sliderBounds: 14...85
    )
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                header

                VStack(alignment: .leading, spacing: 16) {
                    
                    // Город
                    Text("Город")
                        .font(.custom("Montserrat-Regular", size: 16))
                    
                    Button(action: {
                        showCityPicker.toggle()
                    }) {
                        HStack {
                            Text(selectedCity)
                                .foregroundColor(selectedCity == "Не выбрано" ? .gray : .black)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                    }
                    // Пол
                    Text("Пол")
                        .font(.custom("Montserrat-Regular", size: 16))
                    
                    HStack {
                        genderButton("Любой")
                        genderButton("Женский")
                        genderButton("Мужской")
                    }

                    // Возраст
                    Text("Возраст")
                        .font(.custom("Montserrat-Regular", size: 16))
                    
                    HStack {
                        RangeSliderView(viewModel: rangeSliderVM) { newRange in
                            minAge = Double(newRange.lowerBound)
                            maxAge = Double(newRange.upperBound)
                        }
                        .padding(.horizontal)
                        HStack(spacing: 4) {
                            Text("\(Int(minAge))")
                            Text("\(Int(maxAge))")
                        }
                    }

                    Spacer()

                    Button(action: {
                        // Применить фильтры
                    }) {
                        Text("Показать результаты")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray)
                            .cornerRadius(12)
                    }
                }
                .padding()
            }
            .sheet(isPresented: $showCityPicker) {
                CityPickerView(selectedCity: $selectedCity)
            }
        }
    }

    private var header: some View {
        HStack {
            Button("Очистить") {
                selectedCity = "Не выбрано"
                selectedGender = "Любой"
                minAge = 18
                maxAge = 35
            }
            .foregroundColor(.black)
            Spacer()
            Text("Фильтры")
                .font(.custom("Montserrat-SemiBold", size: 18))
            Spacer()
            Button(action: {
                // Закрыть фильтры, можно добавить dismiss или привязку
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.black)
            }
        }
        .padding(.horizontal)
    }

    private func genderButton(_ title: String) -> some View {
        Button(action: {
            selectedGender = title
        }) {
            Text(title)
                .foregroundColor(selectedGender == title ? .white : .black)
                .padding()
                .frame(maxWidth: .infinity)
                .background(selectedGender == title ? Color.blue : Color(.secondarySystemBackground))
                .cornerRadius(10)
        }
    }
}



struct CityPickerView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedCity: String
    @State private var searchText = ""

    private let allCities: [String] = [
        "Любое", "Воронеж", "Москва", "Санкт-Петербург", "Волгоград",
        "Владивосток", "Екатеринбург", "Казань", "Калининград",
        "Краснодар", "Красноярск", "Нижний Новгород", "Новосибирск", "Омск"
    ]

    var filteredCities: [String] {
        if searchText.isEmpty {
            return allCities
        } else {
            return allCities.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(filteredCities, id: \.self) { city in
                    HStack {
                        Text(city)
                        Spacer()
                        if city == selectedCity {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedCity = city
                        dismiss()
                    }
                }
            }
            .searchable(text: $searchText)
            .navigationTitle("Город")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }
}

#Preview {
    FiltersView()
}
