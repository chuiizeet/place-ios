//
//  ColorPop.swift
//  reddit-place
//
//  Created by chuy g on 27/04/22.
//

import Popovers
import SwiftUI

enum ColorViewConstants {
    static var sliderHeight = CGFloat(40)
    static var cornerRadius = CGFloat(12)
    
    /// padding outside all items
    static var padding = CGFloat(12)
    
    /// space between items
    static var spacing = CGFloat(10)
}

struct ColorView: View {
    @State var present = false
    @ObservedObject var viewModel: ColorViewModel
    
    var buttonSize: CGFloat
    var buttonColorSize: CGFloat
    
    var body: some View {
        Button {
            present = true
        } label: {
            
            Circle()
                .fill(Color.white)
                .frame(width: buttonSize, height: buttonSize)
                .shadow(color: Color.black.opacity(0.15), radius: 1.25, x: 1, y: 1)
                .overlay(
                    Circle()
                        .fill(viewModel.color, strokeBorder: Color.black, lineWidth: 2.5)
                        .frame(width: buttonColorSize, height: buttonColorSize)
                    
                    , alignment: .center
                )
        }
        .popover(
            present: $present,
            attributes: {
                $0.sourceFrameInset.bottom = -8
                $0.position = .absolute(
                    originAnchor: .bottom,
                    popoverAnchor: .top
                )
            }
        ) {
            ColorViewPopover(model: viewModel)
        }
    }
}

struct ColorViewPopover: View {
    @ObservedObject var model: ColorViewModel
    
    var body: some View {
        VStack {
            Text("Choose a color")
                .bold()
                .foregroundColor(Color(.label))
            
            PaletteView(selectedColor: $model.selectedColor)
                .cornerRadius(ColorViewConstants.cornerRadius)
            
        }
        .padding(.vertical, 24)
        .padding(12)
        .frame(width: 200)
        .background(
            ZStack {
                Templates.VisualEffectView(.systemUltraThinMaterialDark)
            }
        )
        .cornerRadius(16)
    }
}

struct PaletteView: View {
    @Binding var selectedColor: ColorsAllowed
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                PaletteButton(color: ColorsAllowed.black, selectedColor: $selectedColor)
                PaletteButton(color: ColorsAllowed.blue, selectedColor: $selectedColor)
                PaletteButton(color: ColorsAllowed.purple, selectedColor: $selectedColor)
                PaletteButton(color: ColorsAllowed.green, selectedColor: $selectedColor)
            }
            .aspectRatio(4, contentMode: .fit)
            
            HStack(spacing: 0) {
                PaletteButton(color: ColorsAllowed.brown, selectedColor: $selectedColor)
                PaletteButton(color: ColorsAllowed.gray, selectedColor: $selectedColor)
                PaletteButton(color: ColorsAllowed.lowgray, selectedColor: $selectedColor)
                PaletteButton(color: ColorsAllowed.white, selectedColor: $selectedColor)
            }
            .aspectRatio(4, contentMode: .fit)
            
            HStack(spacing: 0) {
                PaletteButton(color: ColorsAllowed.red, selectedColor: $selectedColor)
                PaletteButton(color: ColorsAllowed.orange, selectedColor: $selectedColor)
                PaletteButton(color: ColorsAllowed.yellow, selectedColor: $selectedColor)
                PaletteButton(color: ColorsAllowed.lowgreen, selectedColor: $selectedColor)
                
            }
            .aspectRatio(4, contentMode: .fit)
            
            HStack(spacing: 0) {
                PaletteButton(color: ColorsAllowed.cyan, selectedColor: $selectedColor)
                PaletteButton(color: ColorsAllowed.moradito, selectedColor: $selectedColor)
                PaletteButton(color: ColorsAllowed.pink, selectedColor: $selectedColor)
                PaletteButton(color: ColorsAllowed.sand, selectedColor: $selectedColor)
            }
            .aspectRatio(4, contentMode: .fit)
        }
    }
}

struct PaletteButton: View {
    var color: ColorsAllowed
    @Binding var selectedColor: ColorsAllowed
    var body: some View {
        Button {
            withAnimation {
                selectedColor = color
            }
        } label: {
            Rectangle()
                .fill(Color.init(uiColor: UIColor(hexaString: color.hex)))
                .overlay(
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                        .font(.system(size: 15, weight: .medium))
                        .shadow(color: Color.black.opacity(0.75), radius: 3, x: 0, y: 1)
                        .opacity(color == selectedColor ? 1 : 0)
                )
        }
    }
}

