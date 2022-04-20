//
//  randomshit.swift
//  reddit-place
//
//  Created by chuy g on 18/04/22.
//

import Foundation
import CoreImage
import UIKit

public struct PixelData {
    var a: UInt8
    var r: UInt8
    var g: UInt8
    var b: UInt8
}

func createRandomUIImage(width: Int, height: Int) -> UIImage? {
    var pixels = [PixelData]()
    let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
    let bitsPerComponent = 8
    let bitsPerPixel = 32
    
    var color = true
    
    for i in 0..<width {
        if i % 16 == 0{
            color.toggle()
        }
        for j in 0..<height {
            if j % 16 == 0{
                color.toggle()
            }
            if color {
                pixels.append(PixelData(a: 255, r: 255, g: 255, b: 255))
            } else {
                pixels.append(PixelData(a: 255, r: 0, g: 0, b: 255))
//                            pixels.append(PixelData(a: .random(in: 0...255), r: .random(in: 0...255), g: .random(in: 0...255), b: .random(in: 0...255)))
            }
        }
    }

    guard let providerRef = CGDataProvider(data: NSData(bytes: &pixels,
                            length: pixels.count * MemoryLayout<PixelData>.size)
        )
        else { return nil }

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
        shouldInterpolate: false,
        intent: .absoluteColorimetric
        )
        else { return nil }
    
    return UIImage(cgImage: cgim)
}
