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
    let canvasWidth: Int = 256
    let canvasHeight: Int = 256
    
    let canvasPixelFactor: Int = Int(UIScreen.main.scale) + 2
    
    /// Computed canvas size
    var canvasWidthComputed: CGFloat {
        return CGFloat(canvasWidth * canvasPixelFactor)
    }
    
    var canvasHeightComputed: CGFloat {
        return CGFloat(canvasWidth * canvasPixelFactor)
    }
    
    @Published var image: UIImage?
    @Published var pixelsImage: [PixelData] = [PixelData]()
    
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
    
    private func changeImage(pixel: Int) {
        if let image = image {
            self.image = processPixels(in: image, index: pixel)
        } else {
            Logger.warning("Image has not been processed yet")
        }
    }
    
    /// Create first image
    private func createImage(completionHandler: @escaping (UIImage?, String?) -> Void){
        
        guard canvasWidth > 0 && canvasHeight > 0 else { fatalError() }

        
        DispatchQueue.global(qos: .utility).async {
            let width = self.canvasWidth * self.canvasPixelFactor
            let height = self.canvasHeight * self.canvasPixelFactor
            let rgbColorSpace =     CGColorSpaceCreateDeviceRGB()
            let bitmapInfo =        CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
            let bitsPerComponent =  8
            let bitsPerPixel =      32
            
            var color = true
            
            var pixels = [PixelData]()
            
            if self.pixelsImage.isEmpty {
                
                for i in 0..<width {
                    if i % self.canvasPixelFactor == 0{
                        color.toggle()
                    }
                    for j in 0..<height {
                        if j % self.canvasPixelFactor == 0{
                            color.toggle()
                        }
                        if color {
                            pixels.append(PixelData(r: 255, g: 0, b: 0, a: 255))
                        } else {
                            pixels.append(PixelData(r: 255, g: 255, b: 255, a: 255))
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    self.pixelsImage = pixels
                }
            } else {
                pixels = self.pixelsImage
            }
            
            guard pixels.count == width * height else { fatalError() }

            Logger.debug("Total pixels: \(pixels.count)", context: pixels.count)
            guard let providerRef = CGDataProvider(data: NSData(bytes: &pixels,
                                    length: pixels.count * MemoryLayout<PixelData>.size)
                )
                else { return completionHandler(nil, "Error weird") }
                            
            guard let cgim = CGImage(
                width: width,
                height: height,
                bitsPerComponent: bitsPerComponent,
                bitsPerPixel: bitsPerPixel,
                bytesPerRow: width * MemoryLayout<PixelData>.size,
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
    
    /// Take and change the pixel in the image
    func processPixels(in image: UIImage, index: Int) -> UIImage? {
        guard let inputCGImage = image.cgImage else {
            print("unable to get cgImage")
            return nil
        }
        let colorSpace       = CGColorSpaceCreateDeviceRGB()
        let width            = inputCGImage.width
        let height           = inputCGImage.height
        let bytesPerPixel    = 4
        let bitsPerComponent = 8
        let bytesPerRow      = bytesPerPixel * width
        let bitmapInfo       = RGBA32.bitmapInfo

        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
            print("unable to create context")
            return nil
        }
        context.draw(inputCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        guard let buffer = context.data else {
            print("unable to get context data")
            return nil
        }

        let pixelBuffer = buffer.bindMemory(to: RGBA32.self, capacity: width * height)

        for row in 0 ..< Int(height) {
            for column in 0 ..< Int(width) {
                let offset = row * width + column
                if offset == index {
                    pixelBuffer[offset] = .blue
                }                
            }
        }

        let outputCGImage = context.makeImage()!
        let outputImage = UIImage(cgImage: outputCGImage, scale: image.scale, orientation: image.imageOrientation)

        return outputImage
    }
    
    /// Get the pixel index from user Touch location
    func setNewPixelFromLocation(_ location: CGPoint) {
        
        let x: Int = Int(location.x)
        let y: Int = Int(location.y)
        guard let image = image else {
            Logger.error("Image has not been processed yet")
            return
        }

        let pixelData = image.cgImage!.dataProvider!.data
        let _: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let canvasWidthNormalize: Int = canvasWidth * canvasPixelFactor

        let pixelIndex: Int = ((canvasWidthNormalize * y) + x)
        
        changeImage(pixel: pixelIndex)
        print(pixelIndex)
    }

}
