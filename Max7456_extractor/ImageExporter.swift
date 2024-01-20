//
//  ImageExporter.swift
//  Max7456_extractor
//
//  Created by Roman on 20.01.2024.
//

import Foundation
import CoreGraphics
import ImageIO
import AppKit

class ImageExporter {

    private var folderURL: URL?
    private lazy var operationQueue: OperationQueue = {
        let oq = OperationQueue()
        oq.qualityOfService = .userInitiated
        return oq
    }()

    func saveImages(_ images: [CGImage]) {
        operationQueue.cancelAllOperations()

        operationQueue.addOperation(
            BlockOperation { [weak self] in
                self?.folderURL = FileManager.default.folderURL()
            }
        )
        operationQueue.addBarrierBlock {}
        images
            .enumerated()
            .forEach { index, image in
                guard let operation = operation(for: image, at: index) else { return }
                operationQueue
                    .addOperation(operation)
            }

        operationQueue.addBarrierBlock { [weak self] in
            guard let folderURL = self?.folderURL else { return }
            NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: folderURL.path)
        }
    }

    private func operation(for image: CGImage, at index: Int) -> Operation? {
        return BlockOperation { [weak self] in
            guard let folderURL = self?.folderURL else {
                return
            }
            let fileURL = folderURL.appendingPathComponent(
                "\(index)",
                conformingTo: .png
            )
            print(fileURL)
            do {
                try image
                    .pngData()?
                    .write(
                        to: fileURL
                    )
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
    }
}

class SaveImageOperation: Operation {

}

private extension FileManager {

    func folderURL(folderName: String = UUID().uuidString) -> URL? {
        let url = temporaryDirectory
            .appendingPathComponent(folderName, conformingTo: .folder)

        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(
                    atPath: url.path,
                    withIntermediateDirectories: true, attributes: nil
                )
                return url
            } catch {
                print(error.localizedDescription)
                return nil
            }
        } else {
            return url
        }
    }
}
