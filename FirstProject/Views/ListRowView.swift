//
//  ListRowView.swift
//  FirstProject
//
//  Created by Raj Shah on 1/22/25.
//


import SwiftUI

struct ListRowView: View {
    let item: ItemModel
    
    var body: some View {
        HStack{
            Image(systemName: item.isCompleted ? "checkmark.circle":"circle")
                .foregroundStyle(item.isCompleted ? .green : .red)
            Text(item.title)
            Spacer()
        }
        .font(.title2)
        .padding(.vertical, 8)
    }
}

