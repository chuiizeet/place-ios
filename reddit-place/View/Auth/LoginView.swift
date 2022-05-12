//
//  LoginView.swift
//  reddit-place
//
//  Created by chuy g on 24/04/22.
//

import SwiftUI
import Drops

struct LoginView: View {
    
    // MARK: - Properties
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModel: ValidationViewModel
    
    @State var showSignUp = false
    @State var showMessages = false
    
    var imageSize: CGFloat {
        return DeviceUtil.screenW * 0.5
    }
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
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
                    TextField("user@email.com", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.body)
                    if showMessages && !viewModel.isEmailValid() {
                        Text("Enter a valid email")
                            .font(.callout)
                            .foregroundColor(.red)
                    }
                    
                    Text("Password")
                        .font(.callout)
                        .bold()
                        .padding(.top)
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.body)
                    if showMessages && !viewModel.isPasswordLength() {
                        Text("Password must be length than 8")
                            .font(.callout)
                            .foregroundColor(.red)
                    }
                    
                    Button {
                        if !viewModel.isLoginComplete() {
                            showMessages = true
                        } else {
                            Task {
                                let result = await viewModel.signIn()
                                if result {
                                    // Notification
                                    let drop = Drop(
                                        title: "Welcome \(viewModel.email) 😄",
                                        subtitle: "",
                                        icon: UIImage(systemName: "person.fill"),
                                        action: .init {
                                            //...
                                            Drops.hideCurrent()
                                        },
                                        position: .top,
                                        duration: 4.0,
                                        accessibility: "Alert: Title, Subtitle"
                                    )
                                    Drops.hideCurrent()
                                    Drops.show(drop)
                                    
                                    // Dismiss
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                        self.presentationMode.wrappedValue.dismiss()
                                    }
                                }
                            }
                        }
                    } label: {
                        HStack {
                            Spacer()
                            Text("Sign in")
                                .font(.title2.bold())
//                                .opacity(viewModel.isLoginComplete() ? 1.0 : 0.5)
                            Spacer()
                        }
                    }
                    .tint(Color(.label))
                    .foregroundColor(Color(.systemBackground))
                    .controlSize(.large)
                    .buttonStyle(.borderedProminent)
                    .padding(.vertical)
//                    .opacity(viewModel.isLoginComplete() ? 1.0 : 0.5)
                    
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
            SignUpView(viewModel: viewModel, showSignUp: $showSignUp)
        } label: {
            EmptyView()
        }

    }
}
