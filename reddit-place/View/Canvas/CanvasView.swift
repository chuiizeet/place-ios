//
//  CanvasView.swift
//  reddit-place
//
//  Created by chuy g on 20/04/22.
//

import SwiftUI

struct CanvasView: View {
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: CanvasViewModel
    @Binding var currentScale: Double
    var maxScale: Double
    
    @State private var overlayOpacity: Double = 0.0
    
    init(viewModel: CanvasViewModel, currentScale: Binding<Double>, maxScale: Double) {
        self.viewModel = viewModel
        self.maxScale = maxScale
        _currentScale = currentScale
    }
    
    var body: some View {
        if let image = viewModel.image {
            Image(uiImage: image)
                .scaledToFit()
                .overlay(
                    Path { path in
                        let pxFactor: CGFloat = CGFloat(viewModel.canvasPixelFactor)
                        
                        for index in 1...Int(viewModel.canvasWidth) - 1 {
                            let start = CGPoint(x: CGFloat(index) * pxFactor, y: 0)
                            let end = CGPoint(x: CGFloat(index) * pxFactor, y: viewModel.canvasHeightComputed)
                            path.move(to: start)
                            path.addLine(to: end)
                        }
                        
                        for index in 1...Int(viewModel.canvasHeight) - 1 {
                            let start = CGPoint(x: 0, y: CGFloat(index) * pxFactor)
                            let end = CGPoint(x: viewModel.canvasWidthComputed, y: CGFloat(index) * pxFactor)
                            path.move(to: start)
                            path.addLine(to: end)
                        }
                        
                        //Close the path.
                        path.closeSubpath()
                        
                    }
                        .stroke(.black.opacity(overlayOpacity), style: StrokeStyle(lineWidth: CGFloat(Double(viewModel.canvasPixelFactor)/2).pixelsToPoints(), lineCap: .round, lineJoin: .round))
//                        .animation(.easeInOut(duration: 0.1), value: overlayOpacity)
                )
            // MARK: - This looks weird, maybe remove animation
                .onChange(of: currentScale) { newValue in
                    let maxValue = 1.0
                    let op = newValue/maxScale
                    let factor = 0.175
//                    withAnimation {
                        if op <= factor {
                            overlayOpacity = 0
                        } else if op >= 0.75 {
                            overlayOpacity = maxValue
                        } else {
                            overlayOpacity = (op - (factor/2))
                        }
//                    }
                }
        } else {
            // Loading
            Text("Loading")
        }
    }
    
    // MARK: - Helper Functions
    
}
