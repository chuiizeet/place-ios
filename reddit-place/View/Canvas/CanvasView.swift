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
    
    var gridWidth: CGFloat {
        return DeviceUtil.screenW/CGFloat(viewModel.canvasWidth)
    }
    
    var gridHeight: CGFloat {
        return DeviceUtil.screenH/CGFloat(viewModel.canvasHeight)
    }
    
    init(viewModel: CanvasViewModel) {
        self.viewModel = viewModel
    }
    
    
    var body: some View {
        if let image = viewModel.image {
            Image(uiImage: image)
                .scaledToFit()
                .overlay(
                    Path { path in
                        let pxFactor: CGFloat = CGFloat(viewModel.canvasPixelFactor)
                        
                        for index in 1...Int(viewModel.canvasWidth) - 1
                        {
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
                    // MARK: TODO - play with opacity + scale
                        .stroke(.black.opacity(1.0), style: StrokeStyle(lineWidth: CGFloat(Double(viewModel.canvasPixelFactor)/2).pixelsToPoints(), lineCap: .round, lineJoin: .round))
                )
        } else {
            Color.black
        }
    }
    
    // MARK: - Helper Functions
    
}
