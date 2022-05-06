//
//  SettingsView.swift
//  reddit-place
//
//  Created by chuy g on 06/05/22.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var viewModel: ValidationViewModel
    
    @State var showAlert = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Account")) {
                    
                    Button {
                        if viewModel.user == .member {
                            showAlert.toggle()
                        } else {
                            
                        }
                    } label: {
                        accountLbl()
                    }
                }
                Section(header: Text("Information"), footer: Text("This app was made with ❤️ by Jesús Guerra powered by Appwrite")) {
                    
                    // Code ...
                    Link(destination: URL(string: "https://github.com/chuiizeet/place-ios")!) {
                        // show code
                        Label {
                            Text("Source code")
                        } icon: {
                            Image(systemName: "chevron.left.forwardslash.chevron.right")
                        }
                        .foregroundColor(Color(.label))
                    }
                    
                    // Appwrite page
                    Link(destination: URL(string: "https://appwrite.io/")!) {
                        // show code
                        Label {
                            Text("Appwrite website")
                                .foregroundColor(Color(.label))
                        } icon: {
                            Image(systemName: "link")
                                .foregroundColor(Color(hex: "#f02e65"))
                        }
                    }
                                        
                    
                }
                .alert("Log out", isPresented: $showAlert) {
                    Button("Log out", role: .destructive) {
                        Task {
                         await viewModel.logOut()
                        }
                    }
                    Button("Cancel", role: .cancel) { }
                    
                    }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    // MARK: - View Builders
    
    @ViewBuilder func accountLbl() -> some View {
        if viewModel.user == .member {
            Label {
                Text(viewModel.currrentEmail)
            } icon: {
                Image(systemName: "person.fill")
            }
            .foregroundColor(Color(.label))
        } else {
            Text("Sign in")
                .foregroundColor(Color(.label))
        }
    }
}
