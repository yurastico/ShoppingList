//
//  WelcomeView.swift
//  ShoppingList
//
//  Created by Yuri Cunha on 28/10/23.
//

import SwiftUI
import Firebase
import FirebaseAuth



struct WelcomeView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var pasword = ""
    @Binding var path: NavigationPath
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Group {
                    TextField("Nome", text: $name)
                        .keyboardType(.namePhonePad)
                        .textContentType(.name) // define o tipo de conteudo, para o teclado sugerir (mt pica)
                    TextField("E-mail", text: $email)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                    SecureField("Senha", text: $pasword)
                        .textContentType(.password)
                        
                }
                .textFieldStyle(.roundedBorder)
                
                VStack(spacing: 16) {
                    Button {
                        signIn()
                    } label: {
                        Text("entrar")
                            .frame(maxWidth: .infinity)
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button {
                        signUp()
                    } label: {
                        Text("Criar conta")
                            
                            .fontWeight(.bold)
                    }
                                        
                    
                }
                .padding(.top)
                .padding(.horizontal,32)
            }
        }
        .navigationTitle("Welcome")
        .padding()
        
    }
    
    private func signUp() {
        Auth.auth().createUser(withEmail: email, password: pasword) { result, error in
            if let error {
                
                print("tratar erros depois \(error.localizedDescription)")
            } else {
                updateUserAndProced(user: result?.user)
            }
        }
    }
    private func signIn() {
        Auth.auth().signIn(withEmail: email, password: pasword) { result, error in
            if let error {
                print("tratar erros depois \(error.localizedDescription)")
            } else {
                updateUserAndProced(user: result?.user)
            }
        }
    }
    
    private func updateUserAndProced(user: User?) {
        if let user, !name.isEmpty {
            let request = user.createProfileChangeRequest()
            request.displayName = name
            request.commitChanges()
        }
        showShoppingList()
    }
    
    private func showShoppingList() {
        path.append(NavigationType.listing)
    }
    
}

#Preview {
    NavigationStack {
        WelcomeView(path: .constant(.init()))
    }
}
