//
//  CGImageExtensions.swift
//  Max7456_extractor
//
//  Created by Roman on 18.01.2024.
//

import CoreGraphics
import Foundation
import ImageIO

extension CGImage {

    private static let pixelDataSize = MemoryLayout<PixelData>.size

    static func image(pixels: [PixelData], width: Int, height: Int)  -> CGImage? {

        guard pixels.count == width * height else {
            return nil
        }
        let data = pixels.withUnsafeBufferPointer(Data.init(buffer:))
        let cfdata = NSData(data: data) as CFData
        guard let provider = CGDataProvider(data: cfdata) else {
            return nil
        }
        return .init(
            width: width,
            height: height,
            bitsPerComponent: 8,
            bitsPerPixel: 32,
            bytesPerRow: width * Self.pixelDataSize,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue),
            provider: provider,
            decode: nil,
            shouldInterpolate: false,
            intent: .defaultIntent
        )
    }

    func pngData() -> Data? {
        let cfdata: CFMutableData = CFDataCreateMutable(nil, 0)
        if let destination = CGImageDestinationCreateWithData(cfdata, kUTTypePNG as CFString, 1, nil) {
            CGImageDestinationAddImage(destination, self, nil)
            if CGImageDestinationFinalize(destination) {
                return cfdata as Data
            }
        }

        return nil
    }
}
