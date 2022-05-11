//
//  ContentView.swift
//  reddit-place
//
//  Created by chuy g on 18/04/22.
//

import SwiftUI
import Logging

struct ContentView: View {
    
    // MARK: - Properties
    
    /// Init values...
    var topEdge: CGFloat
    var bottomEdge: CGFloat
    
    @StateObject private var gestureHandler = GestureHandler()
    @StateObject private var viewModel = CanvasViewModel()
    @StateObject private var authViewModel = ValidationViewModel()
    @StateObject private var colorViewModel = ColorViewModel()    
    
    private let baseScale: Double = 0.15
    
    private let maxScale: Double = 20.0
    
    // Butons...
    private var buttonSize: CGFloat {
        return DeviceUtil.absScreenH * 0.05725
    }
    private var buttonImageSize: CGFloat {
        return buttonSize * 0.55
    }
    private var buttonColorSize: CGFloat {
        return buttonSize * 0.70
    }
    
    @State var offset: CGSize = .zero
    @State var scaleAnchor: UnitPoint = .center
    @State var accumulated = CGSize.zero
    @State var showLogin: Bool = false
    @State var showSettings: Bool = false
    
    var image: UIImage?
    
    // Timer...
    @State private var timeRemaining = 0
    @State private var isDelayed: Bool = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(
        bottomEdge: CGFloat,
        topEdge: CGFloat
    ) {
        self.bottomEdge = bottomEdge
        self.topEdge = topEdge
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Controls...
                VStack {
                    HStack {
                        // Reset
                        Button(action: {
                            accumulated = .zero
                            gestureHandler.reset()
                        }) {
                            Circle()
                                .fill(Color.white)
                                .frame(width: buttonSize, height: buttonSize)
                                .shadow(color: Color.black.opacity(0.15), radius: 1.25, x: 1, y: 1)
                                .overlay(
                                    Image(systemName: "arrow.up.left.and.down.right.magnifyingglass")
                                        .resizable()
                                        .foregroundColor(Color.black)
                                        .frame(width: buttonImageSize, height: buttonImageSize)
                                    
                                    , alignment: .center
                                )
                        }
                        Spacer()
                        Button(action: {
                            showSettings.toggle()
                        }) {
                            Circle()
                                .fill(Color.white)
                                .frame(width: buttonSize, height: buttonSize)
                                .shadow(color: Color.black.opacity(0.15), radius: 1.25, x: 1, y: 1)
                                .overlay(
                                    Image(systemName: "gearshape.fill")
                                        .resizable()
                                        .foregroundColor(Color.black)
                                        .frame(width: buttonImageSize, height: buttonImageSize)
                                    
                                    , alignment: .center
                                )
                        }
                    }
                    .padding(.horizontal, 16)
                    Spacer()
                    // Bottom tools
                    HStack {
                        Button(action: {
                            // Get color
                            Logger.debug("Get color", context: nil)
                        }) {
                            ColorView(viewModel: colorViewModel, buttonSize: buttonSize, buttonColorSize: buttonColorSize)
                        }
                        Spacer()
                        
                        Button {
                            // .. Scale
                            if authViewModel.user == .guest {
                                showLogin = true
                            } else {
                                //....
                            }
                            
                            // .. Press a pixel
                        } label: {
                            buttonContent()
                        }
                        .tint(colorViewModel.color)
                        .foregroundColor(colorViewModel.bgColor)
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large) // .large, .medium or .small
                        
                        Spacer()

                        
                        // Zoom in
                        Button(action: {
                            gestureHandler.plusScale(scale: gestureHandler.scale + gestureHandler.scaleFactor, maximum: maxScale)
                        }) {
                            Circle()
                                .fill(Color.white)
                                .frame(width: buttonSize, height: buttonSize)
                                .shadow(color: Color.black.opacity(0.15), radius: 1.25, x: 1, y: 1)
                                .overlay(
                                    Image(systemName: "plus.magnifyingglass")
                                        .resizable()
                                        .foregroundColor(Color.black)
                                        .frame(width: buttonImageSize, height: buttonImageSize)
                                    
                                    , alignment: .center
                                )
                        }
                        
                        // Zoom out
                        Button(action: {
                            gestureHandler.plusScale(scale: gestureHandler.scale - gestureHandler.scaleFactor, maximum: maxScale)
                        }) {
                            Circle()
                                .fill(Color.white)
                                .frame(width: buttonSize, height: buttonSize)
                                .shadow(color: Color.black.opacity(0.15), radius: 1.25, x: 1, y: 1)
                                .overlay(
                                    Image(systemName: "minus.magnifyingglass")
                                        .resizable()
                                        .foregroundColor(Color.black)
                                        .frame(width: buttonImageSize, height: buttonImageSize)
                                    
                                    , alignment: .center
                                )
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.bottom, 24 + bottomEdge)
                .padding(.top, 16 + topEdge)
                .frame(width: DeviceUtil.absScreenW, height: DeviceUtil.absScreenH)
                .zIndex(2)
                
                ZStack(alignment: .center) {
                    Color.gray.brightness(0.33)
                        .ignoresSafeArea(.all)
                    
                    CanvasView(viewModel: viewModel, currentScale: $gestureHandler.scale, maxScale: maxScale)
                        .overlay(
                            TappableView { gesture in
                                
                                // user guest
                                if authViewModel.user == .guest {
                                    // login to pixrl
                                    
                                }
                                
                                // Place a pixel
                                if !isDelayed && timeRemaining == 0 {
                                    let location = gesture.location(in: gesture.view)
                                    
                                    Task {
                                        let result = await viewModel.colorAPixel(location: location, hex: colorViewModel.selectedColor.hex)
                                        switch result {
                                            //... nah
                                        case .idle: break
                                        case .placed:
                                            print("SUCCESS - PLACED")
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                self.timeRemaining = 30
                                                self.isDelayed = true
                                            }
                                            break
                                        case .time:
                                            print("FAILED - TIME")
                                            break
                                        case .error:
                                            print("Error")
                                            break
                                        }
                                    }
                                }
                            })
                        .sheet(isPresented: $showSettings) {
                            //dismiss
                        } content: {
                            //content
                            SettingsView(viewModel: authViewModel, gestureHandler: gestureHandler)
                        }
                }
                .zIndex(0)
                .ignoresSafeArea(.all, edges: [.top, .bottom])
                .frame(width: CGFloat(viewModel.canvasWidth) * 16, height: CGFloat(viewModel.canvasWidth) * 16)
                .offset(gestureHandler.offset)
                .scaleEffect(gestureHandler.scale, anchor: scaleAnchor)
                .gesture(magnificationGesture).ignoresSafeArea()
                .animation(.linear(duration: 0.1), value: offset)
                .animation(.default, value: gestureHandler.scale)
                .simultaneousGesture(
                    DragGesture()
                        .onChanged { value in
                            gestureHandler.offset = CGSize(width: (value.translation.width + self.accumulated.width), height: value.translation.height + self.accumulated.height)
                        }
                        .onEnded { value in
                            gestureHandler.offset = CGSize(width: value.translation.width + self.accumulated.width, height: value.translation.height + self.accumulated.height)
                            accumulated = gestureHandler.offset
                            
                            let canvasSizeX = CGFloat(viewModel.canvasWidth) * 16
                            let canvasSizeY = CGFloat(viewModel.canvasHeight) * 16
                            scaleAnchor = UnitPoint(x:value.location.x / canvasSizeX, y:value.location.y / canvasSizeY)
                            // MARK: - Improve this
                            scaleAnchor = .center
                        }
                )
                .sheet(isPresented: $showLogin) {
                    //dismiss
                } content: {
                    //content
                    LoginView(viewModel: authViewModel)
                }
                .onAppear(perform: {
                    _ = AppwriteUtils.shared.realtime.subscribe(channel: "collections.\(K.Appwrite.canvasCollectionId).documents", callback: { param in
                        // Callback will be executed on all account events.
                        
                        if let dict = param.payload {
                            let doc = Doc.from(map: dict)
                            Logger.debug("Reload image", context: nil)
                            viewModel.realtimePixel(doc: doc)
                        }
                        
                    })
                })
                .navigationBarHidden(true)
                .onReceive(timer) { time in
                    guard isDelayed else { return }

                    if timeRemaining > 0 {
                        timeRemaining -= 1
                        if timeRemaining == 0 {
                            // Time complete
                            isDelayed = false
                        }
                    }
                }
            }
        }
        .task {
            await authViewModel.verifyUser()
            await viewModel.fetchPixels()
        }
    }
    
    // MARK: - ViewBuilders
    
    @ViewBuilder func buttonContent() -> some View {
        if authViewModel.user == .guest {
            Text("Sign in to color")
                .font(.title3.bold())
        } else {
            if isDelayed && timeRemaining > 0 {
                Text("You can place a pixel in \(timeRemaining) seconds")
                    .font(.body.bold())
            } else {
                Text("Touch a pixel to color")
                    .font(.body.bold())
            }
        }
    }
}

// MARK: Gesture
extension ContentView {
    //    var tapGesture: some Gesture {
    //        let singleTap = TapGesture(count: 1)
    //            .onEnded {
    //                gestureHandler.onSingleTapGestureEnded()
    //            }
    //        // Reset ....
    //        let doubleTap = TapGesture(count: 2)
    //            .onEnded {
    //                gestureHandler.onDoubleTapGestureEnded(
    //                    scaleMaximum: baseScale,
    //                    doubleTapScale: baseScale
    //                )
    //            }
    //        return ExclusiveGesture(doubleTap, singleTap)
    //    }
    var magnificationGesture: some Gesture {
        MagnificationGesture()
        
//            .onChanged {
//                gestureHandler.onMagnificationGestureChanged(
//                    value: $0, scaleMaximum: maxScale
//                )
//            }
        //            .onEnded {
        //                gestureHandler.onMagnificationGestureEnded(
        //                    value: $0, scaleMaximum: maxScale
        //                )
        //            }
    }
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: .zero, coordinateSpace: .local)
            .onChanged(gestureHandler.onDragGestureChanged)
            .onEnded(gestureHandler.onDragGestureEnded)
    }
}
