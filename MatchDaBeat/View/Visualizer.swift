//
//  Visualizer.swift
//  MatchDaBeat
//
//  Created by Richard Price on 16/08/2019.
//  Copyright © 2019 twisted echo. All rights reserved.
//
import UIKit
import AVFoundation
import MetalKit
import simd
import Accelerate

let top = "#include <metal_stdlib>\n"+"#include <simd/simd.h>\n"+"using namespace metal;"
let vertexStruct = "struct Vertex {vector_float4 color; vector_float2 pos;};"
let vertexOutStruct = "struct VertexOut{float4 color; float4 pos [[position]];};"
//MARK :- step 9 add new shaders
let uniformStruct = "struct Uniform{float scale;};"
let vertexShader = "vertex VertexOut vertexShader(const device Vertex *vertexArray [[buffer(0)]],const device Uniform *uniformArray [[buffer(1)]], unsigned int vid [[vertex_id]]){Vertex in = vertexArray[vid];VertexOut out;out.color = in.color; float scale = uniformArray[0].scale; float x = in.pos.x * scale; float y = in.pos.y * scale; out.pos = float4(x, y, 0, 1);return out;};"

let fragmentShader = "fragment float4 fragmentShader(VertexOut interpolated [[stage_in]]){return interpolated.color;};"


public class Visualizer : UIView {
    
    private var engine : AVAudioEngine
    private var metalView : MTKView!
    private var metalDevice : MTLDevice!
    private var metalQueue : MTLCommandQueue!
    private var pipelineState: MTLRenderPipelineState!
    private var vertexBuffer: MTLBuffer!
    //MARK :- step 10 add uniform buffer
    private var uniformBuffer: MTLBuffer!
    
    struct Vertex {
        var color : simd_float4
        var pos : simd_float2
    }
    //MARK :- step 11 add unifmor struct and scale property
    struct Uniform {
        var scale : Float
    }
    
    var uniform : [Uniform] = [Uniform(scale: 0.5)]
    var vertices : [Vertex] = []
    let originVertice = Vertex(color: [1,1,1,1], pos: [0,0])
    
    var scaleValue : Float = 0.5 {
        didSet{
            uniform = [Uniform(scale: scaleValue)]
            uniformBuffer = metalDevice.makeBuffer(bytes: uniform, length: uniform.count * MemoryLayout<Uniform>.stride, options: [])!
            DispatchQueue.main.async {
                self.metalView.setNeedsDisplay()
            }
        }
    }
    
    public required init(engine: AVAudioEngine) {
        self.engine = engine
        super.init(frame: .zero)
        //MARK :- step 12 create vertices function
        makeVertices() //important:- draw vertices first
        setupMetal()
        setupView()
        setupEngineTap()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    //MARK :- step 12 create vertices function
    fileprivate func makeVertices(){
        func degreesToRads(forValue x: Float)->Float32{
            return (Float.pi*x)/180
        }
        for i in 0..<720 {
            let position : simd_float2 = [cos(degreesToRads(forValue: Float(i)))*1,sin(degreesToRads(forValue: Float(i)))*1]
            if (i+1)%2 == 0 {
                vertices.append(originVertice)
            }
            let vertice = Vertex(color: [1,1,1,1], pos: position)
            vertices.append(vertice)
        }
    }

    fileprivate func setupView(){
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
    }
    
    fileprivate func setupMetal(){
        //metalView
        metalView = MTKView()
        metalView.backgroundColor = .clear
        metalView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(metalView)
        metalView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        metalView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        metalView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        metalView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        metalView.delegate = self
        //metalDevice
        metalDevice = MTLCreateSystemDefaultDevice()
        metalView.device = metalDevice
//MARK :- step 13 uncomment
        metalView.isPaused = true
        metalView.enableSetNeedsDisplay = true
        
        //metalQueue
        metalQueue = metalDevice.makeCommandQueue()!

        do {
            pipelineState = try buildRenderPipelineWith(device: metalDevice, metalKitView: metalView)
        } catch {
            print(error)
        }
        vertexBuffer = metalDevice.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Vertex>.stride, options: [])!
        //MARK :- step 14 add uniform buffer
        uniformBuffer = metalDevice.makeBuffer(bytes: uniform, length: uniform.count * MemoryLayout<Uniform>.stride, options: [])!
    }
    
     //MARK :- step 15 amend tap engine
    public func setupEngineTap(){
        engine.mainMixerNode.installTap(onBus: 0, bufferSize: 1024, format: nil) { (buffer, time) in
            //DispatchQueue.global(qos: .userInitiated).async{
                //let volume = CGFloat(self.getVolume(from: buffer, bufferSize: 1024)) + 1
                //self.aniamteCircle(volume: volume)
            self.rms(from: buffer, with: 1024)
            }
        }
    //MARK :- step 16 remove volume function add new rms public func
    public func rms(from buffer: AVAudioPCMBuffer, with bufferSize: UInt){
        guard let channelData = buffer.floatChannelData?[0] else {return}
        var val = Float(0);
        vDSP_vsq(channelData, 1, channelData, 1, bufferSize) //square
        vDSP_meanv(channelData, 1, &val, bufferSize) //mean
        val = val + 0.5
        print(val)
        if val == 0.5 {return}
        scaleValue = val
    }
}
//    fileprivate func aniamteCircle(volume: CGFloat){
//        DispatchQueue.main.async {
//            if volume > 1.1 {
//                print(volume)
//                self.circle.transform = CGAffineTransform.identity
//                self.circle.transform = CGAffineTransform(scaleX: volume , y: volume)
//            } else {
//                self.circle.transform = CGAffineTransform.identity
//            }
//        }
   //}
//    fileprivate func getVolume(from buffer: AVAudioPCMBuffer, bufferSize: Int) -> Float {
//        guard let channelData = buffer.floatChannelData?[0] else {
//            return 0
//        }
//
//        let channelDataArray = Array(UnsafeBufferPointer(start:channelData, count: bufferSize))
//
//        var outEnvelope = [Float]()
//        var envelopeState:Float = 0
//        let envConstantAtk:Float = 0.16
//        let envConstantDec:Float = 0.003
//
//        for sample in channelDataArray {
//            let rectified = abs(sample)
//
//            if envelopeState < rectified {
//                envelopeState += envConstantAtk * (rectified - envelopeState)
//            } else {
//                envelopeState += envConstantDec * (rectified - envelopeState)
//            }
//            outEnvelope.append(envelopeState)
//        }
//        // 0.007 is the low pass filter to prevent
//        // getting the noise entering from the microphone
//        if let maxVolume = outEnvelope.max(),
//            maxVolume > Float(0.015) {
//            return maxVolume
//        } else {
//            return 0.0
//        }
//    }


extension Visualizer : MTKViewDelegate {
    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    }
    
    public func draw(in view: MTKView) {
        guard let commandBuffer = metalQueue.makeCommandBuffer() else {return}
        guard let renderDescriptor = view.currentRenderPassDescriptor else {return}
        //MARK :- step 17 amend clear color
        renderDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0, 0, 0, 0)
        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderDescriptor) else {return}
        //We tell it what render pipeline to use
        renderEncoder.setRenderPipelineState(pipelineState)
        // What vertex buffer data to use
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        //MARK :- step 18 add uniform buffer abd draw privtives
        renderEncoder.setVertexBuffer(uniformBuffer, offset: 0, index: 1)
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)

        renderEncoder.endEncoding()
        commandBuffer.present(view.currentDrawable!)
        commandBuffer.commit()
    }
    
    func buildRenderPipelineWith(device: MTLDevice, metalKitView: MTKView) throws -> MTLRenderPipelineState {
        let pipelineDescriptor = MTLRenderPipelineDescriptor()

        //MARK :- step 19 new shader to include unfoirm struct
        let shader = top + vertexStruct + uniformStruct + vertexOutStruct + vertexShader + fragmentShader
        let library = try! device.makeLibrary(source: shader, options: nil)
        pipelineDescriptor.vertexFunction = library.makeFunction(name: "vertexShader")
        pipelineDescriptor.fragmentFunction = library.makeFunction(name: "fragmentShader")
        
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalKitView.colorPixelFormat
        
        return try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
}

