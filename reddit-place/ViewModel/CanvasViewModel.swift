//
//  CanvasViewModel.swift
//  reddit-place
//
//  Created by chuy g on 20/04/22.
//

import SwiftUI

class CanvasViewModel: ObservableObject {
    
    // MARK: - Properties
    /// The canvas properties hardcoded for test and demostration
    let canvasWidth: Int = 500
    let canvasHeight: Int = 500
    
    let canvasPixelFactor: Int = Int(UIScreen.main.scale) + 2
    
    /// Computed canvas size
    var canvasWidthComputed: CGFloat {
        return CGFloat(canvasWidth * canvasPixelFactor)
    }
    
    var canvasHeightComputed: CGFloat {
        return CGFloat(canvasWidth * canvasPixelFactor)
    }
    
    @Published var image: UIImage?
    @Published var pixelsArray: [Pixel] = [Pixel]()
    
    init() {
        createImage { image, _ in
            if let image = image {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
        
    }
    
    // MARK: - Helper Functions
    
    func computedCoords(location: CGPoint, hex: String = "#f02e65") {
        let x = Int(ceil((location.x / CGFloat(canvasPixelFactor))))
        let y = Int(ceil((location.y / CGFloat(canvasPixelFactor))))
        Logger.debug("x:\(x) y: \(y)", context: nil)
        
        
        let startXPx = x > 0 ? Int((x-1) * canvasPixelFactor) : 1
        let endXPx = Int(x * canvasPixelFactor)
        
        let startYPx = y > 0 ? Int((y-1) * canvasPixelFactor) : 1
        let endYPx = Int(y * canvasPixelFactor)
        
        for i in startXPx..<endXPx{
            for j in startYPx..<endYPx{
                let offset: Int = (Int(canvasWidthComputed) * j) + i
                pixelsArray[offset] = Pixel(hexString: hex)
            }
        }
        // Recreate image
        createImage { image, _ in
            if let image = image {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
    
    /// Create image
    private func createImage(completionHandler: @escaping (UIImage?, String?) -> Void){
        
        guard canvasWidth > 0 && canvasHeight > 0 else { fatalError() }

        
        DispatchQueue.global(qos: .utility).async {
            let width = self.canvasWidth * self.canvasPixelFactor
            let height = self.canvasHeight * self.canvasPixelFactor
            let rgbColorSpace =     CGColorSpaceCreateDeviceRGB()
            let bitmapInfo =        CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue) // premultipliedLast or .none
            let bitsPerComponent =  8
            let bitsPerPixel =      32
            
            var color = true
            
            var pixels = [Pixel]()
            // Create first image
            if self.pixelsArray.isEmpty {
                
                for i in 0..<width {
                    if i % self.canvasPixelFactor == 0{
                        color.toggle()
                    }
                    for j in 0..<height {
                        if j % self.canvasPixelFactor == 0{
                            color.toggle()
                        }
                        if color {
                            pixels.append(Pixel(r: 255, g: 255, b: 255, a: 255))
                        } else {
                            pixels.append(Pixel(r: 222, g: 222, b: 222, a: 255))
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    self.pixelsArray = pixels
                }
            } else {
                pixels = self.pixelsArray
            }
            
//            guard pixels.count == width * height else { fatalError() }

            Logger.debug("Total pixels: \(pixels.count)", context: pixels.count)
            guard let providerRef = CGDataProvider(data: NSData(bytes: &pixels,
                                    length: pixels.count * MemoryLayout<Pixel>.size)
                )
                else { return completionHandler(nil, "Error weird") }
                            
            guard let cgim = CGImage(
                width: width,
                height: height,
                bitsPerComponent: bitsPerComponent,
                bitsPerPixel: bitsPerPixel,
                bytesPerRow: width * MemoryLayout<Pixel>.size,
                space: rgbColorSpace,
                bitmapInfo: bitmapInfo,
                provider: providerRef,
                decode: nil,
                shouldInterpolate: true,
                intent: .absoluteColorimetric
                )
                else { return completionHandler(nil, "Error weird") }
//            let image = UIImage(cgImage: cgim, scale: UIScreen.main.scale, orientation: .up)
            completionHandler(UIImage(cgImage: cgim), nil)
        }
    }
    
//    /// Get the pixel index from user Touch location
//    func setNewPixelFromLocation(_ location: CGPoint) {
//        
//        let x: Int = Int(location.x)
//        let y: Int = Int(location.y)
//        guard let image = image else {
//            Logger.error("Image has not been processed yet")
//            return
//        }
//
//        let pixelData = image.cgImage!.dataProvider!.data
//        let _: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
//        
//        let canvasWidthNormalize: Int = canvasWidth * canvasPixelFactor
//
//        let pixelIndex: Int = ((canvasWidthNormalize * y) + x)
//        
////        changeImage(pixel: pixelIndex)
//    }

}
