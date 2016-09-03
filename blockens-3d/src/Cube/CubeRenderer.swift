//
// Created by Bjorn Tipling on 7/28/16.
// Copyright (c) 2016 apphacker. All rights reserved.
//

import Foundation
import MetalKit

struct CubeRotation {
    let x: Float32
    let y: Float32
    let z: Float32
}

class CubeRenderer: Renderer {

    let renderUtils: RenderUtils

    var pipelineState: MTLRenderPipelineState! = nil

    var cubeVertexBuffer: MTLBuffer! = nil
    var colorBuffer: MTLBuffer! = nil
    var cubeRotationBuffer: MTLBuffer! = nil

    init (utils: RenderUtils) {
        renderUtils = utils
    }

    func loadAssets(device: MTLDevice, view: MTKView, frameInfo: FrameInfo) {

        pipelineState = renderUtils.createPipeLineState("cubeVertex", fragment: "cubeFragment", device: device, view: view)
        cubeVertexBuffer = renderUtils.createCubeVertexBuffer(device, bufferLabel: "cube vertices")


        let bufferSize = sizeof(Float32) * renderUtils.cubeColors.count
        colorBuffer = device.newBufferWithLength(bufferSize, options: [])
        colorBuffer.label = "cube colors"

        let contents = colorBuffer.contents()
        let pointer = UnsafeMutablePointer<Float32>(contents)
        pointer.initializeFrom(renderUtils.cubeColors)

        cubeRotationBuffer = renderUtils.createSizedBuffer(device, bufferLabel: "cube rotation")

        updateCubeRotation(frameInfo)
        print("loading cube assets done")
    }

    func update(frameInfo: FrameInfo) {
        updateCubeRotation(frameInfo)
    }

    private func updateCubeRotation(frameInfo: FrameInfo) {
        var cubeRotation = CubeRotation(x: frameInfo.rotateX, y: frameInfo.rotateY, z: frameInfo.rotateZ)
        let contents = cubeRotationBuffer.contents()
        let pointer = UnsafeMutablePointer<CubeRotation>(contents)
        pointer.initializeFrom(&cubeRotation, count: 1)
    }


    func render(renderEncoder: MTLRenderCommandEncoder) {

        renderUtils.setPipeLineState(renderEncoder, pipelineState: pipelineState, name: "cube")
        renderEncoder.setCullMode(MTLCullMode.Back)
        renderEncoder.setFrontFacingWinding(MTLWinding.Clockwise)
        for (i, vertexBuffer) in [cubeVertexBuffer, colorBuffer].enumerate() {
            renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, atIndex: i)
        }

        renderUtils.drawPrimitives(renderEncoder, vertexCount: 6) //renderUtils.numVerticesInACube())

    }
}
