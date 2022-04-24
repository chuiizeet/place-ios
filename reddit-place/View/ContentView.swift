//
//  ContentView.swift
//  reddit-place
//
//  Created by chuy g on 18/04/22.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Properties
    
    @StateObject private var gestureHandler = GestureHandler()
    @StateObject var viewModel = CanvasViewModel()
    
    private let baseScale: Double = 1.0
    private let scaleFactor: Double = 2.0
    private let maxScale: Double = 20.0
    
    @State var offset: CGSize = .zero
    @State private var accumulated = CGSize.zero
    
    var image: UIImage?
    init() {
    }
    
    var body: some View {
        
        ZStack(alignment: .center) {
            Color.gray.brightness(0.33)
                .ignoresSafeArea(.all)
            
            CanvasView(viewModel: viewModel, currentScale: $gestureHandler.scale, maxScale: maxScale)
                .overlay(
                    TappableView { gesture in
                        viewModel.computedCoords(location: gesture.location(in: gesture.view))
                        //                            viewModel.setNewPixelFromLocation(gesture.location(in: gesture.view))
                    })
            
            // MARK: - TODO: Layout this
            // Controls...
            VStack(alignment: .center) {
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
            .zIndex(1)
            .padding(.bottom, 32)
        }
        .frame(width: CGFloat(viewModel.canvasWidth) * 16, height: CGFloat(viewModel.canvasWidth) * 16)
        .scaleEffect(gestureHandler.scale, anchor: gestureHandler.scaleAnchor)
        .offset(offset).gesture(tapGesture) // .gesture(dragGesture)
        .gesture(magnificationGesture).ignoresSafeArea()
        .animation(.linear(duration: 0.1), value: gestureHandler.offset)
        .animation(.default, value: gestureHandler.scale)
        .simultaneousGesture(
            DragGesture()
                .onChanged { value in
                    offset = CGSize(width: value.translation.width + self.accumulated.width, height: value.translation.height + self.accumulated.height)
                }
                .onEnded { value in
                    offset = CGSize(width: value.translation.width + self.accumulated.width, height: value.translation.height + self.accumulated.height)
                    accumulated = offset
                    //
                }
        )
    }
}

// MARK: Gesture
extension ContentView {
    var tapGesture: some Gesture {
        let singleTap = TapGesture(count: 1)
            .onEnded {
                gestureHandler.onSingleTapGestureEnded()
            }
        // Reset ....
        let doubleTap = TapGesture(count: 2)
            .onEnded {
                gestureHandler.onDoubleTapGestureEnded(
                    scaleMaximum: baseScale,
                    doubleTapScale: baseScale
                )
            }
        return ExclusiveGesture(doubleTap, singleTap)
    }
    var magnificationGesture: some Gesture {
        MagnificationGesture()
            .onChanged {
                gestureHandler.onMagnificationGestureChanged(
                    value: $0, scaleMaximum: maxScale
                )
            }
            .onEnded {
                gestureHandler.onMagnificationGestureEnded(
                    value: $0, scaleMaximum: maxScale
                )
            }
    }
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: .zero, coordinateSpace: .local)
            .onChanged(gestureHandler.onDragGestureChanged)
            .onEnded(gestureHandler.onDragGestureEnded)
    }
}
