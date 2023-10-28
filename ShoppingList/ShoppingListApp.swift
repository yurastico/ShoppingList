//
//  ShoppingListApp.swift
//  ShoppingList
//
//  Created by Yuri Cunha on 28/10/23.
//

import SwiftUI
import FirebaseCore
@main
struct ShoppingListApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
