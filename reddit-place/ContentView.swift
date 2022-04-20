//
//  ContentView.swift
//  reddit-place
//
//  Created by chuy g on 18/04/22.
//

import SwiftUI

struct ContentView: View {
    
    var image: UIImage?
    
    @StateObject private var gestureHandler = GestureHandler()
    
    init() {
        let height = 4096
        let width = 4096
        
        image = createRandomUIImage(width: width, height: height)
    }
    
    var body: some View {
        
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                .scaleEffect(gestureHandler.scale, anchor: gestureHandler.scaleAnchor)
                            .offset(gestureHandler.offset).gesture(tapGesture).gesture(dragGesture)
                            .gesture(magnificationGesture).ignoresSafeArea()
                            .animation(.linear(duration: 0.1), value: gestureHandler.offset)
                            .animation(.default, value: gestureHandler.scale)
                            
        }
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
                    scaleMaximum: 8.0,
                    doubleTapScale: 8.0
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
//    var controlPanelDismissGesture: some Gesture {
//        DragGesture().onEnded {
//            gestureHandler.onControlPanelDismissGestureEnded(
//                value: $0, dismissAction: { viewStore.send(.onPerformDismiss) }
//            )
//        }
//    }
}
