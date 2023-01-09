//
//  ContentView.swift
//  iExpense
//
//  Created by artembolotov on 09.01.2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var expenses = Expenses()
    @State private var showingAddExpense = false
    
    private var personalExpenses: [ExpenseItem] {
        expenses.items.filter { $0.type == "Personal"}
    }
    
    private var businessExpenses: [ExpenseItem] {
        expenses.items.filter { $0.type == "Business" }
    }
    var body: some View {
        NavigationView {
            List {
                Section("Personal") {
                    ForEach(personalExpenses) { ExpenseCell(item: $0) }
                        .onDelete { indexSet in
                            removeItems(at: indexSet, subArray: personalExpenses)
                        }
                }
                Section("Business") {
                    ForEach(businessExpenses) { ExpenseCell(item: $0) }
                        .onDelete { indexSet in
                            removeItems(at: indexSet, subArray: businessExpenses)
                        }
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button {
                    showingAddExpense = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
            }
        }
    }
    
    func removeItems(at offsets: IndexSet, subArray: [ExpenseItem]) {
        offsets.forEach { index in
            let item = subArray[index]
            if let index = expenses.items.firstIndex(where: { $0.id == item.id }) {
                expenses.items.remove(at: index)
            }
        }
    }
}

struct ExpenseCell: View {
    let item: ExpenseItem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                Text(item.type)
            }
            Spacer()
            Text(item.amount, format: .currency(code: "USD"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
