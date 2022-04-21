//
//  PixelData.swift
//  rdit-place
//
//  Created by chuy g on 20/04/22.
//

import UIKit
import CoreImage

struct PixelData: Equatable {

    var r: UInt8
    var g: UInt8
    var b: UInt8
    var a: UInt8
    
    static let r            = PixelData(r: 255, g: 0,   b: 0,   a: 255)
    static let g            = PixelData(r: 0,   g: 255, b: 0,   a: 255)
    static let b            = PixelData(r: 0,   g: 0,   b: 255, a: 255)
    static let white        = PixelData(r: 255, g: 255, b: 255, a: 255)
    static let black        = PixelData(r: 0,   g: 0,   b: 0,   a: 255)
    static let magenta      = PixelData(r: 255, g: 0,   b: 255, a: 255)
    static let yellow       = PixelData(r: 255, g: 255, b: 0,   a: 255)
    static let cyan         = PixelData(r: 0,   g: 255, b: 255, a: 255)

    static func ==(lhs: PixelData, rhs: PixelData) -> Bool {
        return lhs.r == rhs.r &&
        lhs.g == rhs.g &&
        lhs.b == rhs.b &&
        lhs.a == rhs.a
    }
}


struct RGBA32: Equatable {
    private var color: UInt32

    var redComponent: UInt8 {
        return UInt8((color >> 24) & 255)
    }

    var greenComponent: UInt8 {
        return UInt8((color >> 16) & 255)
    }

    var blueComponent: UInt8 {
        return UInt8((color >> 8) & 255)
    }

    var alphaComponent: UInt8 {
        return UInt8((color >> 0) & 255)
    }

    init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        let red   = UInt32(red)
        let green = UInt32(green)
        let blue  = UInt32(blue)
        let alpha = UInt32(alpha)
        color = (red << 24) | (green << 16) | (blue << 8) | (alpha << 0)
    }

    static let red     = RGBA32(red: 255, green: 0,   blue: 0,   alpha: 255)
    static let green   = RGBA32(red: 0,   green: 255, blue: 0,   alpha: 255)
    static let blue    = RGBA32(red: 0,   green: 0,   blue: 255, alpha: 255)
    static let white   = RGBA32(red: 255, green: 255, blue: 255, alpha: 255)
    static let black   = RGBA32(red: 0,   green: 0,   blue: 0,   alpha: 255)
    static let magenta = RGBA32(red: 255, green: 0,   blue: 255, alpha: 255)
    static let yellow  = RGBA32(red: 255, green: 255, blue: 0,   alpha: 255)
    static let cyan    = RGBA32(red: 0,   green: 255, blue: 255, alpha: 255)

    static let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue

    static func ==(lhs: RGBA32, rhs: RGBA32) -> Bool {
        return lhs.color == rhs.color
    }
}
