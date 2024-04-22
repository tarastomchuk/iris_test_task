import AVKit
import CoreImage
import CoreImage.CIFilterBuiltins
import Foundation

struct SampleBufferTransformer {
    
    func transform(videoSampleBuffer: CMSampleBuffer) -> CMSampleBuffer {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(videoSampleBuffer) else {
            print("failed to get pixel buffer")
            fatalError()
        }
        let inputImage = CIImage(cvImageBuffer: pixelBuffer)
        let colorInvertFilter = CIFilter.colorInvert()
        let context = CIContext()
        
        colorInvertFilter.inputImage = inputImage

        guard let outputImage = colorInvertFilter.outputImage else {
            fatalError()
        }
        
        context.render(outputImage, to: pixelBuffer)

        guard let result = try? pixelBuffer.mapToSampleBuffer(timestamp: videoSampleBuffer.presentationTimeStamp) else {
            fatalError()
        }

        return result
    }
}
