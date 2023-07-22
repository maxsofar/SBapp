//
//  LoginView.swift
//  SBapp
//
//  Created by Max on 01/07/2023.
//

import SwiftUI

struct User {
    let email: String
    let password: String
}

class UserViewModel: ObservableObject {
    @Published var registeredUsers: [User] = []
    
    func register(email: String, password: String) -> Bool {
        if email.isEmpty || password.isEmpty {
            return false
        }
        
        let newUser = User(email: email, password: password)
        registeredUsers.append(newUser)
        return true
    }
    
    func login(email: String, password: String) -> Bool {
        if let _ = registeredUsers.first(where: { $0.email == email && $0.password == password }) {
            return true
        }
        return false
    }
}


struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var signUp: Bool = false
    @FocusState private var isFocused: FormField?
    @StateObject private var viewModel = UserViewModel()
    @State private var showAlert = false
    
    enum FormField {
       case email, password
     }
    
    var body: some View {
        GeometryReader {geometry in
            ZStack {
                Rectangle()
                .frame(width: geometry.size.width, height: geometry.size.height)
                .opacity(0.001)   // <--- important
//                .layoutPriority(-1)
                .onTapGesture {
                    isFocused = nil
                }
                    
                VStack {
                    Image(signUp ? "SignUp" : "Login")
                        .resizable()
                        .scaledToFit()
                        .padding([.bottom], 70)
                    
                    HStack {
                        Image(systemName: "at")
                            .foregroundColor(.secondary)
                        TextField("Email", text: $email)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .focused($isFocused, equals: .email)
                            .submitLabel(.next)
                            .onSubmit {
                                isFocused = .password
                            }
                            .font(.title)
                            .background(
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(.secondary)
                                    .offset(y: 17)
                            )
                            .environment(\.layoutDirection, .leftToRight)
                    }
                    .padding()
                    .environment(\.layoutDirection, .leftToRight)
                    
                    HStack {
                        Image(systemName: "lock")
                            .foregroundColor(.secondary)
                            .scaleEffect(1.3)
                        
                        SecureField("Password", text: $password)
                            .font(.title)
                            .focused($isFocused, equals: .password)
                            .textContentType(.password)
                            .keyboardType(.asciiCapable)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .background(
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(.secondary)
                                    .offset(y: 17)
                            )
                            .frame(height: 10)
                    }
                    .padding()
                    .environment(\.layoutDirection, .leftToRight)
                    Button(action: {
                        if signUp {
                            let success = viewModel.register(email: email, password: password)
                            if success {
                                showAlert = true
                            }
                        } else {
                            let success = viewModel.login(email: email, password: password)
                            if success {
                                showAlert = true
                            }
                        }
                        
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .frame(width: geometry.size.width * 0.9, height: 55)
                            Text(signUp
                                 ? NSLocalizedString("Sign Up (Verb)", comment: "Verb")
                                 : NSLocalizedString("Log In (Verb)", comment: "Verb")
                            )
                                .foregroundColor(.white)
                                .font(.title)
                        }
                    }
                    .padding([.top], 50)
                    HStack {
                        Text(signUp ? "Already registered?" : "Not yet registered?")
                            .font(.title3)
                        Button {
                            signUp.toggle()
                        } label: {
                                Text(signUp
                                    ? NSLocalizedString("Log In (Adverb)", comment: "Adverb")
                                    : NSLocalizedString("Sign Up (Adverb)", comment: "Adverb"))
                                .font(.title3)
                        }
                        
                        .foregroundColor(.blue)
                    }
                    .padding([.top], 30)
                }
                .navigationTitle(signUp
                                 ? Text(NSLocalizedString("Sign Up (Noun)", comment: "Noun"))
                                 : Text(NSLocalizedString("Log In (Noun)", comment: "Noun"))
                )
                .navigationBarTitleDisplayMode(.large)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Success"), message: Text("You have successfully registered/logged in."), dismissButton: .default(Text("OK")))
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

    
