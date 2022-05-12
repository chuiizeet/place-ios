//
//  SignUpView.swift
//  reddit-place
//
//  Created by chuy g on 24/04/22.
//

import SwiftUI

struct SignUpView: View {
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: ValidationViewModel
    
    @Binding var showSignUp: Bool
    @State var showMessages = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                
                Text("Nickname (optional)")
                    .font(.callout)
                    .bold()
                TextField("0xChuy.guerra 🐛", text: $viewModel.nickname)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.body)
                
                Text("Email")
                    .font(.callout)
                    .bold()
                TextField("user@email.com", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.body)
                if showMessages && !viewModel.isEmailValid() {
                    Text("Enter a valid email")
                        .font(.callout)
                        .foregroundColor(.red)
                        .padding(.bottom)
                }
                
                Text("Password")
                    .font(.callout)
                    .bold()
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.body)
                if showMessages && !viewModel.isPasswordLength() {
                    Text("Password must be length than 8")
                        .font(.callout)
                        .foregroundColor(.red)
                }
                
                Button {
                    if !viewModel.isSignUpComplete() {
                        showMessages = true
                    } else {
                        Task {
                            let status = try? await viewModel.signUp()
                            if let success = status {
                                if success == .success {
                                    // Show cool message in future
                                    DispatchQueue.main.async(execute: {
                                        self.showSignUp = false
                                    })
                                }
                            }
                        }                        
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text("Sign Up")
                            .font(.title2.bold())
                        Spacer()
                    }
                }
                .tint(Color(.label))
                .foregroundColor(Color(.systemBackground))
                .controlSize(.large)
                .buttonStyle(.borderedProminent)
                .padding(.vertical)
                
                HStack(alignment: .center, spacing: 4) {
                    Spacer()
                    Group {
                        Text("Already have an account?")
                        Button {
                            showSignUp = false
                        } label: {
                            Text("Sign In")
                                .underline()
                        }
                    }
                    .foregroundColor(Color(.label))
                    Spacer()
                }
                .padding(.vertical)
            }
            .padding(.top, 24)
            .padding(.horizontal, 24)
        }
        .navigationTitle("Sign Up")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: Button(action: {
            showSignUp = false
        }, label: {
            HStack(spacing: 4) {
                Image(systemName: "chevron.backward")
                Text("Sign In")
            }
            .font(.body)
            .foregroundColor(Color(.label))
        }))
    }
}
