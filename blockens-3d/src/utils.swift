//
// Created by Bjorn Tipling on 7/28/16.
// Copyright (c) 2016 apphacker. All rights reserved.
//

import Foundation
import Cocoa

let ROTATION_CHANGE_MODIFIER: Float = 0.1;

struct FrameInfo {
    var viewWidth: Int32
    var viewHeight: Int32
    var viewDiffRatio: Float32
    var rotateX: Float32
    var rotateY: Float32
    var rotateZ: Float32
}

let A_KEY: UInt16 = 0
let S_KEY: UInt16 = 1
let D_KEY: UInt16 = 2
let F_KEY: UInt16 = 3
let B_KEY: UInt16 = 11
let W_KEY: UInt16 = 13
let P_KEY: UInt16 = 35
let N_KEY: UInt16 = 45

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