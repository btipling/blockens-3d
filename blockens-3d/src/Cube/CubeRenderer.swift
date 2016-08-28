//
// Created by Bjorn Tipling on 7/28/16.
// Copyright (c) 2016 apphacker. All rights reserved.
//

import Foundation
import MetalKit


class CubeRenderer: Renderer {

    let renderUtils: RenderUtils

    var pipelineState: MTLRenderPipelineState! = nil

    var cubeVertexBuffer: MTLBuffer! = nil
    var colorBuffer: MTLBuffer! = nil

    init (utils: RenderUtils) {
        renderUtils = utils
    }

    func loadAssets(device: MTLDevice, view: MTKView, frameInfo: FrameInfo) {

        pipelineState = renderUtils.createPipeLineState("cubeVertex", fragment: "cubeFragment", device: device, view: view)
        cubeVertexBuffer = renderUtils.createCubeVertexBuffer(device, bufferLabel: "cube vertices")
        colorBuffer = renderUtils.createBufferFromFloatArray(device, count: renderUtils.cubeColors.count, bufferLabel: "cube colors")
        renderUtils.updateBufferFromFloatArray(colorBuffer, data: renderUtils.cubeColors)


        print("loading cube assets done")
    }



    func render(renderEncoder: MTLRenderCommandEncoder) {

        renderUtils.setPipeLineState(renderEncoder, pipelineState: pipelineState, name: "cube")

        for (i, vertexBuffer) in [cubeVertexBuffer, colorBuffer].enumerate() {
            renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, atIndex: i)
        }

        renderUtils.drawPrimitives(renderEncoder, vertexCount: renderUtils.numVerticesInACube())

    }
}
