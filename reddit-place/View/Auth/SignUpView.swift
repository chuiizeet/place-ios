//
//  SignUpView.swift
//  reddit-place
//
//  Created by chuy g on 24/04/22.
//

import SwiftUI

struct SignUpView: View {
    
    // MARK: - Properties
    
    @State var name: String = ""
    @State var email: String = ""
    @State var password: String = ""
    
    @Binding var showSignUp: Bool
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                Text("Name")
                    .font(.callout)
                    .bold()
                TextField("User", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom)
                    .font(.body)
                
                Text("Email")
                    .font(.callout)
                    .bold()
                TextField("user@email.com", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom)
                    .font(.body)
                
                Text("Password")
                    .font(.callout)
                    .bold()
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.body)
                    .padding(.bottom)
                
                Button {
                    // Login...
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
