//
//  ArrayExtensions.swift
//  Max7456_extractor
//
//  Created by Roman on 20.01.2024.
//

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
