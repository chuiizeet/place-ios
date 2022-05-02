//
//  ColorViewModel.swift
//  reddit-place
//
//  Created by chuy g on 27/04/22.
//

import Foundation
import UIKit
import SwiftUI

/// The colors are the beautiful PICO-8 palette
/// https://lospec.com/palette-list/pico-8
enum ColorsAllowed: CaseIterable {
    case black, blue, purple, green, brown, gray, lowgray, white, red, orange, yellow, lowgreen, cyan, moradito, pink, sand
    
    var hex: String {
        switch self {
        case .black:
            return "#000000"
        case .blue:
            return "#1D2B53"
        case .purple:
            return "#7E2553"
        case .green:
            return "#008751"
        case .brown:
            return "#AB5236"
        case .gray:
            return "#5F574F"
        case .lowgray:
            return "#C2C3C7"
        case .white:
            return "#FFF1E8"
        case .red:
            return "#FF004D"
        case .orange:
            return "#FFA300"
        case .yellow:
            return "#FFEC27"
        case .lowgreen:
            return "#00E436"
        case .cyan:
            return "#29ADFF"
        case .moradito:
            return "#83769C"
        case .pink:
            return "#FF77A8"
        case .sand:
            return "#FFCCAA"
        }
    }
}

class ColorViewModel: ObservableObject {
    @Published var selectedColor: ColorsAllowed = ColorsAllowed.black
    
    var color: Color {
        return Color(hex: selectedColor.hex)
    }
    
    var bgColor: Color {
        switch selectedColor {
        case .white:
            return Color(hex: "343A40")
        case .lowgray:
            return Color(hex: "343A40")
        case .yellow:
            return Color(hex: "343A40")
        case .lowgreen:
            return Color(hex: "343A40")
        case .sand:
            return Color(hex: "343A40")
        default:
            return Color(hex: ColorsAllowed.white.hex)
        }
    }
}
