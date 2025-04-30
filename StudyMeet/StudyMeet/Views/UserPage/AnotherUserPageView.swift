//
//  AnotherUserPageView.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 30.04.2025.
//

import SwiftUI

struct AnotherUserPageView: View {
    
    @StateObject private var viewModel: AnnouncementListViewModel
    
    init(viewModel: AnnouncementListViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}
