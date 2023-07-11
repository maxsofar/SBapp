//
//  Register.swift
//  SBapp
//
//  Created by Max on 04/07/2023.
//

import SwiftUI

struct SignUp: View {
    @State private var email = ""
    @State private var password = ""
    @FocusState private var isFocused: FormField?
    
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
                    Image("Login")
                        .resizable()
                        .scaledToFit()
                        .padding([.bottom], 70)
                    //                    .border(.red)
                    
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
                    }
                    .padding()
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
                    Button(action: {
                        // Handle login or sign up action
                        
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .frame(width: geometry.size.width * 0.9, height: 55)
                            Text("Log In")
                                .foregroundColor(.white)
                                .font(.title)
                        }
                    }
                    .padding([.top], 50)
                    HStack {
                        Text("Want to Join?")
                            .font(.title3)
                        NavigationLink("Sign Up"){
                            LoginView()
                        }
                        .font(.title3)
                        .foregroundColor(.blue)
                    }
                    .padding([.top], 30)
                }
                .navigationTitle("Sign Up")
                .navigationBarTitleDisplayMode(.large)
            }
        }
    }
}

struct SignUpView_Previews : PreviewProvider {
    static var previews: some View {
        SignUp()
    }
}
