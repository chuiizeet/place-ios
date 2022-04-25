//
//  LoginView.swift
//  reddit-place
//
//  Created by chuy g on 24/04/22.
//

import SwiftUI

struct LoginView: View {
    
    // MARK: - Properties
    
    @State var email: String = ""
    @State var password: String = ""
    
    @State var showSignUp = false
    
    var imageSize: CGFloat {
        return DeviceUtil.screenW * 0.5
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    
                    // NavigationLinks
                    navigationLinks()
                    
                    HStack {
                        Spacer()
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: imageSize, height: imageSize)
                        Spacer()
                    }
                    
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
                        .padding(.top)
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.body)
                    
                    Button {
                        // Login...
                    } label: {
                        HStack {
                            Spacer()
                            Text("Sign in")
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
                            Text("Don't have an account? ")
                            Button {
                                showSignUp = true
                            } label: {
                                Text("Create One")
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
            .navigationTitle("Sign In")
            .navigationBarTitleDisplayMode(.large)            
        }
    }
    
    @ViewBuilder func navigationLinks() -> some View {
        NavigationLink(isActive: $showSignUp) {
            SignUpView(showSignUp: $showSignUp)
        } label: {
            EmptyView()
        }

    }
}
