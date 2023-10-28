//
//  ShoppingListView.swift
//  ShoppingList
//
//  Created by Yuri Cunha on 28/10/23.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift
struct ShoppingListView: View {
    @State private var itens: [ShoppingItem] = []
    @State private var username: String?
    private let firestore = Firestore.firestore()
    @State private var listener: ListenerRegistration?
    @State private var isAlertShown = false
    @State private var name = ""
    @State private var quantity = 0
    @State private var id = ""
    @Binding var path: NavigationPath
    private let collection = "shoppingList"
    var body: some View {
        Group {
            if !itens.isEmpty {
                List {
                    ForEach(itens) { item in
                        Button {
                            name = item.name
                            quantity = item.quantity
                            id = item.id
                            isAlertShown = true
                        } label: {
                            HStack {
                                Text(item.name)
                                    .tint(.accentColor)
                                Spacer()
                                Text(item.quantity.description)
                                    .tint(.gray)
                            }
                        }
                    }
                    .onDelete(perform: delete)
                }
            } else {
                Text("Voce nao tem produtos cadastrados\nna sua lista de compras")
                    .multilineTextAlignment(.center)
                    .italic()
            }
        }
        .navigationTitle(Auth.auth().currentUser?.displayName ?? "Produtos")
        .alert("Entre com os dados do produto:",isPresented: $isAlertShown) {
            TextField("Nome",text: $name)
            TextField("Quantidade",value: $quantity,format: .number)
            
            Button("ok") {
                if id.isEmpty {
                    createItem()
                } else {
                    let item = ShoppingItem(id: id, name: name, quantity: quantity)
                    editItem(item)
                    id = ""
                }
            }
            Button("cancel") {
                
            }
        }
        .toolbar {
            Button("Sair") {
                do {
                    
                    try Auth.auth().signOut()
                    //TODO IMPLEMENT LOGOUT
                } catch {
                    print(error)
                }
                
            }
            Button("",systemImage: "plus") {
                clearTempData()
                isAlertShown = true
                
            }
        }
        .onAppear {
            load()
        }
    }
    
    private func clearTempData() {
        quantity = 0
        name = ""
    }
    
    private func delete(indexSet: IndexSet) {
        if let index = indexSet.first {
            let item = itens[index]
            firestore.collection(collection)
                .document(item.id)
                .delete()
        }
    }
    private func editItem(_ item: ShoppingItem) {
        firestore.collection(collection).document(item.id)
            .updateData(["name": item.name,"quantity": item.quantity])
    }
    private func createItem() {
        firestore.collection(collection)
            .addDocument(data: ["name": name,"quantity": quantity])
    }
    private func load() {
        listener = firestore.collection(collection)
            .addSnapshotListener(includeMetadataChanges: true, listener: { snapshot, error in
            if let error {
                print(error)
                return
            }
            guard let snapshot else { return }
         
            if snapshot.metadata.isFromCache || snapshot.documentChanges.count > 0 {
                showItemsFromSnapshot(snapshot: snapshot)
            }
            
            
            
        })
    }
    
    private func showItemsFromSnapshot(snapshot: QuerySnapshot) {
        itens.removeAll()
        var newItems: [ShoppingItem] = []
        for document in snapshot.documents {
            let id = document.documentID
            let name = document["name"] as? String ?? ""
            let quantity = document["quantity"] as? Int ?? 0
            let item = ShoppingItem(id: id, name: name, quantity: quantity)
            newItems.append(item)
            print(item.name
            )
        }
        itens = newItems
    }
}

#Preview {
    ShoppingListView(path: .constant(.init()))
}
