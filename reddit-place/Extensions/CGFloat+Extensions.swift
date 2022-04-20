//
//  CGFloat+Extensions.swift
//  reddit-place
//
//  Created by chuy g on 20/04/22.
//

import UIKit

public extension CGFloat {
    /**
     Converts pixels to points based on the screen scale. For example, if you
     call CGFloat(1).pixelsToPoints() on an @2x device, this method will return
     0.5.
     
     - parameter pixels: to be converted into points
     
     - returns: a points representation of the pixels
     */
    func pixelsToPoints() -> CGFloat {
        return self / UIScreen.main.scale
    }
    
    /**
     Returns the number of points needed to make a 1 pixel line, based on the
     scale of the device's screen.
     
     - returns: the number of points needed to make a 1 pixel line
     */
    static func onePixelInPoints() -> CGFloat {
        return CGFloat(1).pixelsToPoints()
    }
}
