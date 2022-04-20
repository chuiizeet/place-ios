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


public extension CGFloat {
    /**
     Converts pixels to points based on the screen scale. For example, if you
     call CGFloat(1).pixelsToPoints() on an @2x device, this method will return
     0.5.
     
     - parameter pixels: to be converted into points
     
     - returns: a points representation of the pixels
     */
    func pixelsToPoints() -> CGFloat {
        return self / UIScreen.main.scale
    }
    
    /**
     Returns the number of points needed to make a 1 pixel line, based on the
     scale of the device's screen.
     
     - returns: the number of points needed to make a 1 pixel line
     */
    static func onePixelInPoints() -> CGFloat {
        return CGFloat(1).pixelsToPoints()
    }
}

extension Shape {
    func fill<Fill: ShapeStyle, Stroke: ShapeStyle>(_ fillStyle: Fill, strokeBorder strokeStyle: Stroke, lineWidth: CGFloat = 1) -> some View {
        self
            .stroke(strokeStyle, lineWidth: lineWidth)
            .background(self.fill(fillStyle))
    }
}
