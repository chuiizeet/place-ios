//
//  ContentView.swift
//  reddit-place
//
//  Created by chuy g on 18/04/22.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Properties
    
    var image: UIImage?
    
    @StateObject private var gestureHandler = GestureHandler()

    init() {
    }
    
    var body: some View {
        
        ZStack {
            Color.gray.brightness(0.5)
                .ignoresSafeArea()
            CanvasView()
                .padding()
                .frame(width: DeviceUtil.screenW, height: DeviceUtil.screenW, alignment: .center)
        }
        .scaleEffect(gestureHandler.scale, anchor: gestureHandler.scaleAnchor)
                    .offset(gestureHandler.offset).gesture(tapGesture).gesture(dragGesture)
                    .gesture(magnificationGesture).ignoresSafeArea()
                    .animation(.linear(duration: 0.1), value: gestureHandler.offset)
                    .animation(.default, value: gestureHandler.scale)
    }
}

// MARK: Gesture
extension ContentView {
    var tapGesture: some Gesture {
        let singleTap = TapGesture(count: 1)
            .onEnded {
                gestureHandler.onSingleTapGestureEnded()
            }
        let doubleTap = TapGesture(count: 2)
            .onEnded {
                gestureHandler.onDoubleTapGestureEnded(
                    scaleMaximum: 1.0,
                    doubleTapScale: 1.0
                )
            }
        return ExclusiveGesture(doubleTap, singleTap)
    }
    var magnificationGesture: some Gesture {
        MagnificationGesture()
            .onChanged {
                gestureHandler.onMagnificationGestureChanged(
                    value: $0, scaleMaximum: 8.0
                )
            }
            .onEnded {
                gestureHandler.onMagnificationGestureEnded(
                    value: $0, scaleMaximum: 8.0
                )
            }
    }
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: .zero, coordinateSpace: .local)
            .onChanged(gestureHandler.onDragGestureChanged)
            .onEnded(gestureHandler.onDragGestureEnded)
    }
}
