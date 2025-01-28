//
//  ListView.swift
//  FirstProject
//
//  Created by Raj Shah on 1/22/25.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var listViewModel: ListViewModel
    @EnvironmentObject var userViewModel: UserViewModel

    var body: some View {
        VStack{
            if listViewModel.items.count == 0 {
                Spacer()
                Text("Add some todos to get started ✨")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
                Spacer()
            }
            else {
                List {
                    ForEach(listViewModel.items) { item in
                        ListRowView(item: item)
                            .onTapGesture(perform: {
                                withAnimation(.linear) {
                                    listViewModel.toggleItem(item: item)
                                }
                            })
                    }
                    .onDelete(perform: listViewModel.deleteItem)
                    .onMove(perform: listViewModel.moveItem)
                }
            }
        }
        .navigationTitle("Todo List 📝")
        .listStyle(PlainListStyle())
        .navigationBarItems(
            leading: EditButton(),
            trailing: NavigationLink("Add", destination: AddView())
        )
        .onAppear {
            listViewModel.updateCollectionName(from: userViewModel)
        }
    }
}

#Preview {
    NavigationView {
        ListView()
    }
    .environmentObject(ListViewModel())
}

