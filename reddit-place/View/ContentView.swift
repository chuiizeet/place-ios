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
    
    private let baseScale: Double = 0.15
    private let scaleFactor: Double = 1.0
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
    
    var image: UIImage?
    
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
                // MARK: - TODO: Layout this
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
                                        .foregroundColor(Color.red)
                                        .frame(width: buttonImageSize, height: buttonImageSize)
                                    
                                    , alignment: .center
                                )
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    Spacer()
                    // Bottom tools
                    HStack {
                        Button(action: {
                            // Get color
                            Logger.debug("Get color", context: nil)
                        }) {
                            Circle()
                                .fill(Color.white)
                                .frame(width: buttonSize, height: buttonSize)
                                .shadow(color: Color.black.opacity(0.15), radius: 1.25, x: 1, y: 1)
                                .overlay(
                                    Circle()
                                        .fill(Color.red, strokeBorder: Color.black, lineWidth: 2.5)
                                        .frame(width: buttonColorSize, height: buttonColorSize)
                                    
                                    , alignment: .center
                                )
                        }
                        Spacer()
                        
                        Button {
                            //...
                        } label: {
                            Text("Color a pixel")
                                .font(.title3.bold())
                        }
                        .tint(.red)
                        .foregroundColor(.white)
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large) // .large, .medium or .small
                        
                        
                        Spacer()

                        
                        // Zoom in
                        Button(action: {
                            gestureHandler.plusScale(scale: gestureHandler.scale + scaleFactor, maximum: maxScale)
                        }) {
                            Circle()
                                .fill(Color.white)
                                .frame(width: buttonSize, height: buttonSize)
                                .shadow(color: Color.black.opacity(0.15), radius: 1.25, x: 1, y: 1)
                                .overlay(
                                    Image(systemName: "plus.magnifyingglass")
                                        .resizable()
                                        .foregroundColor(Color.red)
                                        .frame(width: buttonImageSize, height: buttonImageSize)
                                    
                                    , alignment: .center
                                )
                        }
                        
                        // Zoom out
                        Button(action: {
                            gestureHandler.plusScale(scale: gestureHandler.scale - scaleFactor, maximum: maxScale)
                        }) {
                            Circle()
                                .fill(Color.white)
                                .frame(width: buttonSize, height: buttonSize)
                                .shadow(color: Color.black.opacity(0.15), radius: 1.25, x: 1, y: 1)
                                .overlay(
                                    Image(systemName: "minus.magnifyingglass")
                                        .resizable()
                                        .foregroundColor(Color.red)
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
                                showLogin.toggle()
                            })
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
                .navigationBarHidden(true)
            }
        }
        .task {
            await authViewModel.getSessions()
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
        
            .onChanged {
                gestureHandler.onMagnificationGestureChanged(
                    value: $0, scaleMaximum: maxScale
                )
            }
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

/*
 VStack {
 Spacer()
 HStack(alignment: .center, spacing: 16) {
 Group {
 // -----
 Button {
 gestureHandler.plusScale(scale: gestureHandler.scale - scaleFactor, maximum: maxScale)
 } label: {
 Image(systemName: "minus.magnifyingglass")
 .font(.system(size: 32))
 }
 // Reset
 Button {
 withAnimation{
 gestureHandler.reset(scale: baseScale)
 }
 } label: {
 Image(systemName: "arrow.up.left.and.down.right.magnifyingglass")
 .font(.system(size: 32))
 }
 // ++++
 Button {
 gestureHandler.plusScale(scale: gestureHandler.scale + scaleFactor, maximum: maxScale)
 } label: {
 Image(systemName: "plus.magnifyingglass")
 .font(.system(size: 32))
 }
 }
 .padding()
 .foregroundColor(Color(.label))
 }
 .frame(height: 66)
 .background(.thinMaterial)
 .cornerRadius(12)
 }
 .zIndex(2)
 */

extension Shape {
    func fill<Fill: ShapeStyle, Stroke: ShapeStyle>(_ fillStyle: Fill, strokeBorder strokeStyle: Stroke, lineWidth: CGFloat = 1) -> some View {
        self
            .stroke(strokeStyle, lineWidth: lineWidth)
            .background(self.fill(fillStyle))
    }
}

extension InsettableShape {
    func fill<Fill: ShapeStyle, Stroke: ShapeStyle>(_ fillStyle: Fill, strokeBorder strokeStyle: Stroke, lineWidth: CGFloat = 1) -> some View {
        self
            .strokeBorder(strokeStyle, lineWidth: lineWidth)
            .background(self.fill(fillStyle))
    }
}
