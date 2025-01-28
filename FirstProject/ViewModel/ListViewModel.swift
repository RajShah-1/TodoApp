//
//  ListViewModel.swift
//  FirstProject
//
//  Created by Raj Shah on 1/22/25.
//

import Foundation
import FirebaseFirestore

class ListViewModel: ObservableObject {
    @Published var items: [ItemModel] = []
    
    private let db = Firestore.firestore()
    var collectionName: String = "unknown-user"

    init() {
        fetchItems()
    }

    func updateCollectionName(from: UserViewModel) {
        self.collectionName = from.userID?.profile?.email ?? "unknown-user"
        fetchItems()
    }
        

    func fetchItems() {
        db.collection(collectionName).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching items: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else { return }
            self.items = documents.compactMap { document in
                try? document.data(as: ItemModel.self)
            }
        }
    }

    func addItem(title: String) {
        let newItem = ItemModel(title: title, isCompleted: false)
        do {
            try db.collection(collectionName).document(newItem.id).setData(from: newItem)
            items.append(newItem)
        } catch {
            print("Error adding item: \(error.localizedDescription)")
        }
    }

    func deleteItem(indexSet: IndexSet) {
        for index in indexSet {
            let item = items[index]
            db.collection(collectionName).document(item.id).delete { error in
                if let error = error {
                    print("Error deleting item: \(error.localizedDescription)")
                }
            }
        }
        items.remove(atOffsets: indexSet)
    }

    func moveItem(from: IndexSet, to: Int) {
        items.move(fromOffsets: from, toOffset: to)
    }

    func toggleItem(item: ItemModel) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            let updatedItem = items[index].toggleCompletion()
            do {
                try db.collection(collectionName).document(updatedItem.id).setData(from: updatedItem)
                items[index] = updatedItem
            } catch {
                print("Error toggling item: \(error.localizedDescription)")
            }
        }
    }
}
