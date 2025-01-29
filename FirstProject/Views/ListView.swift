import SwiftUI

struct ListView: View {
    @EnvironmentObject var listViewModel: ListViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var itemToEdit: ItemModel?
    @State private var isEditingItem = false

    private func filterTodos() -> (active: [ItemModel], completed: [ItemModel]) {
        let active = listViewModel.items.filter { !$0.isCompleted }
        let completed = listViewModel.items.filter { $0.isCompleted }
        return (active, completed)
    }
    
    private func makeActiveSection(todos: [ItemModel]) -> some View {
        Section(header: Text("Active")) {
            ForEach(todos) { item in
                ListRowView(item: item)
                    .onTapGesture {
                        withAnimation(.linear) {
                            listViewModel.toggleItem(item: item)
                        }
                    }
                    .swipeActions(edge: .leading) {
                        Button {
                            itemToEdit = item
                            isEditingItem = true
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.blue)
                    }
            }
            .onDelete(perform: { indexSet in
                indexSet.forEach { index in
                    if let itemToDelete = todos[safe: index] {
                        listViewModel.deleteItem(item: itemToDelete)
                    }
                }
            })
            .onMove(perform: { source, destination in
                var activeArray = todos
                activeArray.move(fromOffsets: source, toOffset: destination)
                let (_, completed) = filterTodos()
                listViewModel.reorderItems(newOrder: activeArray + completed)
            })
        }
    }
    
    private func makeCompletedSection(todos: [ItemModel]) -> some View {
        Section(header: Text("Completed").foregroundColor(.gray)) {
            ForEach(todos) { item in
                ListRowView(item: item)
                    .onTapGesture {
                        withAnimation(.linear) {
                            listViewModel.toggleItem(item: item)
                        }
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            withAnimation {
                                listViewModel.deleteItem(item: item)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .swipeActions(edge: .leading) {
                        Button {
                            itemToEdit = item
                            isEditingItem = true
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.blue)
                    }
            }
        }
    }
    
    var body: some View {
        VStack {
            if listViewModel.items.isEmpty {
                Spacer()
                Text("Add some todos to get started ✨")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
                Spacer()
            } else {
                let (activeTodos, completedTodos) = filterTodos()
                
                List {
                    makeActiveSection(todos: activeTodos)
                    
                    if !completedTodos.isEmpty {
                        makeCompletedSection(todos: completedTodos)
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
        }
        .sheet(isPresented: $isEditingItem) {
            if let item = itemToEdit {
                NavigationView {
                    EditItemView(item: item) { updatedTitle in
                        listViewModel.updateItem(item: item, newTitle: updatedTitle)
                        itemToEdit = nil
                    }
                }
            }
        }
        .navigationTitle("Todo List 📝")
        .navigationBarItems(
            leading: EditButton(),
            trailing: NavigationLink("Add", destination: AddView())
        )
        .onAppear {
            listViewModel.updateCollectionName(from: userViewModel)
        }
    }
}

extension Array {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

#Preview {
    NavigationView {
        ListView()
    }
    .environmentObject(ListViewModel())
}
