//
//  PixelData.swift
//  rdit-place
//
//  Created by chuy g on 20/04/22.
//

import UIKit
import CoreImage

struct Pixel: Equatable {

    var r: UInt8
    var g: UInt8
    var b: UInt8
    var a: UInt8
    
    static let r            = Pixel(r: 255, g: 0,   b: 0,   a: 255)
    static let g            = Pixel(r: 0,   g: 255, b: 0,   a: 255)
    static let b            = Pixel(r: 0,   g: 0,   b: 255, a: 255)
    static let white        = Pixel(r: 255, g: 255, b: 255, a: 255)
    static let black        = Pixel(r: 0,   g: 0,   b: 0,   a: 255)
    static let magenta      = Pixel(r: 255, g: 0,   b: 255, a: 255)
    static let yellow       = Pixel(r: 255, g: 255, b: 0,   a: 255)
    static let cyan         = Pixel(r: 0,   g: 255, b: 255, a: 255)

    static func ==(lhs: Pixel, rhs: Pixel) -> Bool {
        return lhs.r == rhs.r &&
        lhs.g == rhs.g &&
        lhs.b == rhs.b &&
        lhs.a == rhs.a
    }
}

extension Pixel {
    init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }        
        self.init(r: UInt8(r), g: UInt8(g), b: UInt8(b), a: UInt8(a))
    }
}

/*
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

 */
