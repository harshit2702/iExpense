//
//  AddView.swift
//  iExpense
//
//  Created by harshit agarwal on 10/05/22.
//

import SwiftUI

struct AddView: View {
    @ObservedObject var expences : Expences
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    
    let types = ["Business" , "Personal"]
    var body: some View {
        NavigationView{
            Form{
                TextField("Name",text: $name)
                Picker("Types", selection: $type){
                    ForEach(types , id: \.self){
                        Text($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                TextField("Amount", value: $amount, format: .currency(code: "INR"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add New Expences")
            .toolbar {
                Button("Save") {
                    let item = expenceItems(name: name, type: type, amount: amount)
                    expences.items.append(item)
                    dismiss()
                }
            }
            
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expences: Expences())
    }
}
