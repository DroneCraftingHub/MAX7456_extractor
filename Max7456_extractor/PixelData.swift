//
//  PixelData.swift
//  Max7456_extractor
//
//  Created by Roman on 18.01.2024.
//

import Foundation

struct PixelData {
    let a: UInt8
    let r: UInt8
    let g: UInt8
    let b: UInt8

    private init(a: UInt8, r: UInt8, g: UInt8, b: UInt8) {
        self.a = a
        self.r = r
        self.g = g
        self.b = b
    }

    static let white = PixelData(
        a: UInt8.max,
        r: UInt8.max,
        g: UInt8.max,
        b: UInt8.max
    )
    static let black = PixelData(
        a: UInt8.max,
        r: 0,
        g: 0,
        b: 0
    )
    static let transparent = PixelData(
        a: 0,
        r: 0,
        g: 0,
        b: 0
    )
}
