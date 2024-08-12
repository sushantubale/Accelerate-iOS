//
//  ImageWrapper.swift
//  Accelerate-iOS
//
//  Created by Sushant Ubale on 8/11/24.
//

import Foundation
import UIKit
import Accelerate
import PhotosUI

struct ImageWrapper {
    let noImageFlag = vImage_Flags(kvImageNoFlags)
    var processedImage: UIImage
    
    init(uiImage: UIImage) {
        self.processedImage = uiImage
        if let buffer = createVIImage(uiImage: self.processedImage) {
            let convertedImage = createToUIImage(buffer: buffer)
            processedImage = convertedImage!
            self.equalizeHistogram()
        }
    }
    
    func createVIImage(uiImage: UIImage) -> vImage_Buffer? {
        guard let cgImage = uiImage.cgImage, let imageBuffer = try? vImage_Buffer(cgImage: cgImage) else {return nil}
        return imageBuffer
    }
    
    func createToUIImage(buffer: vImage_Buffer) -> UIImage? {
        guard let orignalImage = processedImage.cgImage, let format = vImage_CGImageFormat(cgImage: orignalImage), let cgImage = try? buffer.createCGImage(format: format) else {return nil}
        let image = UIImage(
          cgImage: cgImage,
          scale: 1.0,
          orientation: processedImage.imageOrientation
        )
        return image
    }
    
    mutating func equalizeHistogram() {
      guard
        // 2
        let image = processedImage.cgImage,
        var imageBuffer = createVIImage(uiImage: processedImage),
        // 3
        var destinationBuffer = try? vImage_Buffer(
          width: image.width,
          height: image.height,
          bitsPerPixel: UInt32(image.bitsPerPixel))
        else {
          // 4
          print("Error creating image buffers.")
          return
      }
      // 5
      defer {
        imageBuffer.free()
        destinationBuffer.free()
      }
        
        // 1
        let error = vImageEqualization_ARGB8888(
          &imageBuffer,
          &destinationBuffer,
          noImageFlag)

        // 2
        guard error == kvImageNoError else {
          printImageError(error: error)
          return
        }

        // 3
        processedImage = createToUIImage(buffer: destinationBuffer)!
    }
    
    mutating func reflectImage() -> UIImage? {
      guard
        let image = processedImage.cgImage,
        var imageBuffer = createVIImage(uiImage: processedImage),
        var destinationBuffer = try? vImage_Buffer(
          width: image.width,
          height: image.height,
          bitsPerPixel: UInt32(image.bitsPerPixel))
      else {
        print("Error creating image buffers.")
        return nil
      }
      defer {
        imageBuffer.free()
        destinationBuffer.free()
      }

      let error = vImageHorizontalReflect_ARGB8888(
        &imageBuffer,
        &destinationBuffer,
        noImageFlag)

      guard error == kvImageNoError else {
          printImageError(error: error)
        return nil
      }

        processedImage = createToUIImage(buffer: destinationBuffer)!
        return processedImage
    }

    func getHistogram(_ image: WrappedImage) -> HistogramLevels? {
        guard
            let cgImage = processedImage.cgImage,
            var imageBuffer = try? vImage_Buffer(cgImage: cgImage)
        else {
            return nil
        }
        defer {
            imageBuffer.free()
        }

        var redArray: [vImagePixelCount] = Array(repeating: 0, count: 256)
        var greenArray: [vImagePixelCount] = Array(repeating: 0, count: 256)
        var blueArray: [vImagePixelCount] = Array(repeating: 0, count: 256)
        var alphaArray: [vImagePixelCount] = Array(repeating: 0, count: 256)
        var error: vImage_Error = kvImageNoError

        redArray.withUnsafeMutableBufferPointer { rPointer in
            greenArray.withUnsafeMutableBufferPointer { gPointer in
                blueArray.withUnsafeMutableBufferPointer { bPointer in
                    alphaArray.withUnsafeMutableBufferPointer { aPointer in
                        var histogram = [
                            rPointer.baseAddress, gPointer.baseAddress,
                            bPointer.baseAddress, aPointer.baseAddress
                        ]
                        histogram.withUnsafeMutableBufferPointer { hPointer in
                            if let hBaseAddress = hPointer.baseAddress {
                                error = vImageHistogramCalculation_ARGB8888(
                                    &imageBuffer,
                                    hBaseAddress,
                                    noImageFlag
                                )
                            }
                        }
                    }
                }
            }
        }

        guard error == kvImageNoError else {
            printImageError(error: error)
            return nil
        }
        let histogramData = HistogramLevels(
            red: redArray,
            green: greenArray,
            blue: blueArray,
            alpha: alphaArray
        )
        return histogramData
    }

}

extension ImageWrapper {
    func printImageError(error: vImage_Error) {
        let errDescription = vImage.Error(vImageError: error).localizedDescription
        print("vImage Error: \(errDescription)")
    }
}

enum WrappedImage {
  case original
  case processed
}

struct HistogramLevels {
    var red: [UInt]
    var green: [UInt]
    var blue: [UInt]
    var alpha: [UInt]
}
