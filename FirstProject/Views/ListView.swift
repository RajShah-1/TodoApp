import SwiftUI

struct ListView: View {
    @EnvironmentObject var listViewModel: ListViewModel
    @EnvironmentObject var userViewModel: UserViewModel

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
