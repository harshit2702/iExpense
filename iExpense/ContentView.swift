//
//  ContentView.swift
//  iExpense
//
//  Created by harshit agarwal on 06/05/22.
//

import SwiftUI

struct expenceItems: Identifiable,Codable{ //Identifiable to remove id: \.id
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}
class Expences: ObservableObject{ //Load itself and Save itself Immediately
    @Published var items = [expenceItems](){
        didSet {
            let encoder = JSONEncoder()
            
            if let encoded = try? encoder.encode(items){
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    init(){
        if let savedItems = UserDefaults.standard.data(forKey: "Items"){    //reads Whatever in "Items" as Data
            if let decodedItems = try? JSONDecoder().decode([expenceItems].self, from: savedItems){  //Actual Job of unarceiving the data
                items = decodedItems
            }
        }
        items = []
    }
    
}

struct ContentView: View {
    @StateObject var expences = Expences()
    @State private var goToView = false
    var body: some View {
        NavigationView {
            List{
                ForEach(expences.items){ item in
                    HStack{
                        VStack(alignment: .leading){
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        Spacer()
                        
                        Text(item.amount, format: .currency(code: "INR"))
                    }
                }
                .onDelete(perform: removeItems)
            }
            .navigationTitle("IExpence")
            .toolbar{
                Button{
                    goToView = true
                }label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $goToView){
                AddView(expences: expences)
            }
        }
    }
    func removeItems(at offsets: IndexSet){
        expences.items.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
