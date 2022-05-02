//
//  UIColor+Extensions.swift
//  reddit-place
//
//  Created by chuy g on 27/04/22.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hexaString: String, alpha: CGFloat = 1) {
        
        let chars = hexaString.first == "#" ? Array(hexaString.dropFirst()) : Array(hexaString)
        
        self.init(red:   .init(strtoul(String(chars[0...1]),nil,16))/255,
                  green: .init(strtoul(String(chars[2...3]),nil,16))/255,
                  blue:  .init(strtoul(String(chars[4...5]),nil,16))/255,
                  alpha: alpha)}
}
