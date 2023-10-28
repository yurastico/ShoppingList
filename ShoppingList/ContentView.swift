//
//  ContentView.swift
//  ShoppingList
//
//  Created by Yuri Cunha on 28/10/23.
//

import SwiftUI
import FirebaseAuth

enum NavigationType {
    case listing
    case welcome
}


struct ContentView: View {
    @State private var path = NavigationPath()
    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if Auth.auth().currentUser != nil {
                    ShoppingListView(path: $path)
                } else {
                    WelcomeView(path: $path)
                       
                }
            }
            .navigationDestination(for: NavigationType.self) { type in
                switch type {
                case .listing:
                    ShoppingListView(path: $path)
                case .welcome:
                    WelcomeView(path: $path)
                }
            }
        }

        }
    }


#Preview {
    ContentView()
}
