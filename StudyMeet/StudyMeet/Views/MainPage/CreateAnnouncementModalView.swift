//
//  CreateAnnouncementModalView.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 06.05.2025.
//

import SwiftUI

struct CreateAnnouncementModal: View {
    @ObservedObject var viewModel: CreateAnnouncementViewModel
    @Environment(\.dismiss) private var dismiss
    
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Announcement Details")) {
                    TextField("Title", text: $viewModel.title)
                    TextEditor(text: $viewModel.description)
                        .frame(minHeight: 100)
                }
                
                Section(header: Text("Tags")) {
                    ForEach(viewModel.tags, id: \.self) { tag in
                        Text(tag)
                    }
                    .onDelete { indices in
                        viewModel.tags.remove(atOffsets: indices)
                    }
                    
                    HStack {
                        TextField("Add tag", text: $viewModel.newTag)
                        Button(action: viewModel.addTag) {
                            Image(systemName: "plus.circle.fill")
                        }
                        .disabled(viewModel.newTag.isEmpty)
                    }
                }
            }
            .navigationTitle("New Announcement")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        Task {
                            await viewModel.createAnnouncement()
                            if viewModel.creationSuccess {
                                dismiss()
                            }
                        }
                    }
                    .disabled(viewModel.title.isEmpty || viewModel.description.isEmpty)
                }
            }
            .alert("Message", isPresented: $viewModel.showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.alertMessage)
            }
        }
    }
}
