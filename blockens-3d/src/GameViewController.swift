//
//  GameViewController.swift
//  blockens
//
//  Created by Bjorn Tipling on 7/22/16.
//  Copyright (c) 2016 apphacker. All rights reserved.
//

import Cocoa
import MetalKit

class GameViewController: NSViewController, MTKViewDelegate {

    var device: MTLDevice! = nil

    var commandQueue: MTLCommandQueue! = nil

    let inflightSemaphore = dispatch_semaphore_create(1)

    var renderers: [Renderer] = Array()
    var cube: CubeController! = nil
    var frameInfo: FrameInfo! = nil

    override func viewDidLoad() {

        super.viewDidLoad()

        let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
        let gameWindow = appDelegate.getWindow()
        cube = CubeController()
        gameWindow.addKeyEventCallback(handleKeyEvent)

        device = MTLCreateSystemDefaultDevice()
        guard device != nil else { // Fallback to a blank NSView, an application could also fallback to OpenGL here.
            print("Metal is not supported on this device")
            self.view = NSView(frame: self.view.frame)
            return
        }

        // Setup view properties.
        let view = self.view as! MTKView
        view.delegate = self
        view.device = device
        view.sampleCount = 4


        let frameInfo = setupFrameInfo(view)

        // Add render controllers, order matters.
        let renderControllers: [RenderController] = [
                SkyController(),
                cube,
        ]

        for renderController in renderControllers {
            renderers.append(renderController.renderer())
        }
        loadAssets(view, frameInfo: frameInfo)
    }
    func handleKeyEvent(event: NSEvent) {

        switch event.keyCode {

            case A_KEY:
                frameInfo.rotateX -= ROTATION_CHANGE_MODIFIER
                break
            case D_KEY:
                frameInfo.rotateX += ROTATION_CHANGE_MODIFIER
                break
            case S_KEY:
                frameInfo.rotateY -= ROTATION_CHANGE_MODIFIER
                break
            case W_KEY:
                frameInfo.rotateY += ROTATION_CHANGE_MODIFIER
                break

            case B_KEY:
                frameInfo.rotateZ -= ROTATION_CHANGE_MODIFIER
                break
            case F_KEY:
                frameInfo.rotateZ += ROTATION_CHANGE_MODIFIER
                break

            case P_KEY:
                break
            case N_KEY:
                break
            default:
                print(event.keyCode)
                break
        }

        frameInfo.rotateX = Float32(Int32(frameInfo.rotateX) % 360);
        frameInfo.rotateY = Float32(Int32(frameInfo.rotateY) % 360);
        frameInfo.rotateZ = Float32(Int32(frameInfo.rotateZ) % 360);

        cube.update(frameInfo)

    }

    func setupFrameInfo(view: MTKView) -> FrameInfo {
        let frame = view.frame
        let width = frame.size.width
        let height = frame.size.height
        let maxDimension = max(width, height)
        let sizeDiff = abs(width - height)
        let ratio: Float = Float(sizeDiff)/Float(maxDimension)

        frameInfo = FrameInfo(
                viewWidth: Int32(width),
                viewHeight: Int32(height),
                viewDiffRatio: ratio,
                rotateX: 0.0,
                rotateY: 0.0,
                rotateZ: 0.0
                )
        return frameInfo
    }

    func loadAssets(view: MTKView, frameInfo: FrameInfo) {
        commandQueue = device.newCommandQueue()
        commandQueue.label = "main command queue"

        for renderer in renderers {
            renderer.loadAssets(device, view: view, frameInfo: frameInfo)
        }
    }

    func drawInMTKView(view: MTKView) {
        dispatch_semaphore_wait(inflightSemaphore, DISPATCH_TIME_FOREVER)

        let commandBuffer = commandQueue.commandBuffer()
        commandBuffer.label = "Frame command buffer"

        commandBuffer.addCompletedHandler{ [weak self] commandBuffer in
            if let strongSelf = self {
                dispatch_semaphore_signal(strongSelf.inflightSemaphore)
            }
            return
        }

        if let renderPassDescriptor = view.currentRenderPassDescriptor, currentDrawable = view.currentDrawable {

            let parallelCommandEncoder = commandBuffer.parallelRenderCommandEncoderWithDescriptor(renderPassDescriptor)

            for renderer in renderers {
                renderer.render(parallelCommandEncoder.renderCommandEncoder())
            }

            parallelCommandEncoder.endEncoding()
            commandBuffer.presentDrawable(currentDrawable)
        }
        commandBuffer.commit()
    }

    func mtkView(view: MTKView, drawableSizeWillChange size: CGSize) {
        // Pass through and do nothing.
    }
}
