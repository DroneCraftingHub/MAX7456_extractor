//
//  ImageManager.swift
//  Max7456_extractor
//
//  Created by Roman on 16.01.2024.
//

import Foundation
import Combine
import CoreGraphics

class ImageReader {

    let url: PassthroughSubject<URL, Never> = .init()

    private(set) lazy var images: AnyPublisher<[CGImage], Error> = url
        .receive(on: operatingQueue)
        .setFailureType(to: Error.self)
        .tryMap { try String(contentsOf: $0) }
        .map {
            [PixelData]($0)
                .chunked(into: 216)
                .compactMap {
                    CGImage.image(pixels: $0, width: 12, height: 18)
                }
        }
        .eraseToAnyPublisher()

    private let operatingQueue = DispatchQueue(
        label: "com.Max7456_extractor.ImageManager.operatingQueue",
        qos: .userInitiated
    )
}

private extension Array where Element == PixelData {
    init(_ contents: String) {
        self.init()

        var lines = contents.split(separator: "\n")

        if lines.first == "MAX7456" {
            lines.removeFirst()
        }

        var x: UInt8 = 0
        var y: UInt8 = 0
        var skip: UInt8 = 0
        for var line in lines {
            if skip > 0 {
                skip -= 1
                continue
            }
            line = .init(line.trimmingCharacters(in: .whitespacesAndNewlines))
            let startIndex = line.startIndex
            for ch in 0...3 {
                let charStart = ch * 2
                let pixelString = line[
                    line.index(
                        startIndex,
                        offsetBy: charStart
                    )...line.index(
                        startIndex,
                        offsetBy: charStart + 1
                    )
                ]
                switch pixelString {
                case "00":
                    append(.black)
                case "01", "11":
                    append(.transparent)
                case "10":
                    append(.white)
                default:
                    break
                }
                x += 1
                if x == 12 {
                    y += 1
                    x = 0
                }
                if y == 18 {
                    skip = 10
                    y = 0
                }
            }
        }
    }
}
