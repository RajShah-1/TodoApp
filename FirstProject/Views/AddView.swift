//
//  AddView.swift
//  FirstProject
//
//  Created by Raj Shah on 1/22/25.
//

import SwiftUI

struct AddView: View {
    
    @EnvironmentObject var listViewModel: ListViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State var text: String = ""
    @State var alertTitle: String = ""
    @State var showAlert: Bool = false
    
    var body: some View {
        ScrollView{
            VStack{
                TextField("Type something here...", text: $text)
                    .padding(.horizontal)
                    .frame(height: 55)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                Button(action: saveButtonPressed,
                       label: {
                        Text("Save".uppercased())
                        .foregroundStyle(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .font(.headline)
                    }
                )
            }
            .padding(14)
        }
        .navigationTitle("Add an Item!")
        .alert(isPresented: $showAlert, content: getAlert)
    }
    
    func saveButtonPressed() {
        if (textIsAppropriate()) {
            listViewModel.addItem(title: text)
            presentationMode.wrappedValue.dismiss()
        } else {
            alertTitle = "Your new todo item is too short!"
            showAlert = true;
        }
    }
    
    func textIsAppropriate() -> Bool {
        return text.count >= 3
    }
    
    func getAlert() -> Alert {
        return Alert(title: Text(alertTitle))
    }
}

#Preview {
    NavigationView{
        AddView()
    }
    .environmentObject(ListViewModel())
}

