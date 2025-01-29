//
//  EditItemView.swift
//  FirstProject
//
//  Created by Raj Shah on 1/28/25.
//


import SwiftUI

struct EditItemView: View {
    let item: ItemModel
    let onSave: (String) -> Void
    
    @Environment(\.dismiss) var dismiss
    @State private var editedTitle: String
    
    init(item: ItemModel, onSave: @escaping (String) -> Void) {
        self.item = item
        self.onSave = onSave
        _editedTitle = State(initialValue: item.title)
    }
    
    var body: some View {
        Form {
            TextField("Todo Title", text: $editedTitle)
                .textInputAutocapitalization(.sentences)
        }
        .navigationTitle("Edit Todo")
        .navigationBarItems(
            leading: Button("Cancel") {
                dismiss()
            },
            trailing: Button("Save") {
                if !editedTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    onSave(editedTitle)
                    dismiss()
                }
            }
            .disabled(editedTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        )
    }
}