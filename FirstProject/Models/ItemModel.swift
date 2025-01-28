//
//  ItemModel.swift
//  FirstProject
//
//  Created by Raj Shah on 1/22/25.
//

import Foundation
import FirebaseFirestore

// Immutable Struct

struct ItemModel : Identifiable, Codable {
    let id: String
    let title: String
    let isCompleted: Bool
    
    init(id: String = UUID().uuidString, title: String, isCompleted: Bool) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
    }
    
    func toggleCompletion() -> ItemModel {
        return ItemModel(id: id, title: title, isCompleted: !isCompleted)
    }
}
