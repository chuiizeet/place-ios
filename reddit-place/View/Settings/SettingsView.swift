//
//  SettingsView.swift
//  reddit-place
//
//  Created by chuy g on 06/05/22.
//

import SwiftUI
import Popovers

struct SettingsView: View {
    
    @ObservedObject var viewModel: ValidationViewModel
    @ObservedObject var gestureHandler: GestureHandler
    
    @AppStorage(K.UserDefaultsKeys.isOnboarding) var isOnboarding: Bool?
    @Environment(\.presentationMode) var presentationMode
    
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
                
                Section(header: Text("Application")) {
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.33) {
                            
                            self.isOnboarding = true
                        }
                    } label: {
                        Label {
                            Text("Show onboarding")
                        } icon: {
                            Image(systemName: "info")
                        }
                    }
                    .foregroundColor(Color(.label))
                    
                    //                    Menu("Zoom factor") {
                    //                        Button("0.25", action: {
                    //                            gestureHandler.set(scaleFactor: 0.25)
                    //                        })
                    //                        Button("0.5", action: {
                    //                            gestureHandler.set(scaleFactor: 0.5)
                    //                        })
                    //                        Button("0.75", action:{
                    //                            gestureHandler.set(scaleFactor: 0.75)
                    //                        })
                    //                        Button("1.0", action: {
                    //                            gestureHandler.set(scaleFactor: 1.0)
                    //                        })
                    //                    }
                    //                    .foregroundColor(Color(.label))
                    
                    Templates.Menu {
                        
                        Templates.MenuButton(title: "0.1", systemImage: nil) { gestureHandler.set(scaleFactor: 0.1) }
                        
                        Templates.MenuButton(title: "0.25", systemImage: nil) { gestureHandler.set(scaleFactor: 0.25) }
                        
                        Templates.MenuButton(title: "0.50", systemImage: nil) { gestureHandler.set(scaleFactor: 0.5) }
                        
                        Templates.MenuButton(title: "0.75", systemImage: nil) { gestureHandler.set(scaleFactor: 0.75) }
                        
                        Templates.MenuButton(title: "1.0", systemImage: nil) { gestureHandler.set(scaleFactor: 1.0) }
                        
                    } label: { fade in
                        Label {
                            Text("Zoom factor")
                        } icon: {
                            Image(systemName: "plus.magnifyingglass")
                        }
                        .foregroundColor(Color(.label))

                        
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
