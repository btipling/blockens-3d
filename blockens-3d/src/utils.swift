//
// Created by Bjorn Tipling on 7/28/16.
// Copyright (c) 2016 apphacker. All rights reserved.
//

import Foundation
import Cocoa

struct FrameInfo {
    let viewWidth: Int32
    let viewHeight: Int32
    let viewDiffRatio: Float32
}

func rgbaToNormalizedGPUColors(r: Int, g: Int, b: Int, a: Int = 255) -> [Float32] {
    return [Float32(r)/255.0, Float32(g)/255.0, Float32(b)/255.0, Float32(a)/255.0]
}

func getRandomNum(n: Int32) -> Int32 {
    return Int32(arc4random_uniform(UInt32(n)))
}

func log_e(n: Double) -> Double {
    return log(n)/log(M_E)
}

func flipImage(image: NSImage) -> NSImage {
    var imageBounds = NSZeroRect
    imageBounds.size = image.size
    let transform = NSAffineTransform()
    transform.translateXBy(0.0, yBy: imageBounds.height)
    transform.scaleXBy(1, yBy: -1)
    let flippedImage = NSImage(size: imageBounds.size)

    flippedImage.lockFocus()
    transform.concat()
    image.drawInRect(imageBounds, fromRect: NSZeroRect, operation: NSCompositingOperation.CompositeCopy, fraction: 1.0)
    flippedImage.unlockFocus()

    return flippedImage
}