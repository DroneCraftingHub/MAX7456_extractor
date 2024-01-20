//
//  ImageViewerView.swift
//  Max7456_extractor
//
//  Created by Roman on 20.01.2024.
//

import Combine
import SwiftUI

struct ImageViewerView: View {

    @ObservedObject var viewModel: ViewModel

    var gridItemLayout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {

        switch viewModel.state {
        case .error(let errorDescription):
            Text(errorDescription)
        case .images(let images):
            ScrollView {
                LazyVGrid(columns: gridItemLayout, spacing: 20) {
                    ForEach(0..<images.count, id: \.self) { imageIdx in
                        Image(images[imageIdx], scale: 1, label: Text("\(imageIdx)"))
                            .resizable()
                            .frame(width: 24, height: 36)
                            .aspectRatio(contentMode: .fit)
                            .border(.green)
                            .padding()
                    }
                    .padding()
                }
                if !images.isEmpty {
                    Button {
                        viewModel.save(images)
                    } label: {
                        Text(viewModel.saveTitle)
                    }
                    .padding()
                }
            }
        case .saving:
            Spacer()
            ProgressView()
            Spacer()
        }
    }
}

extension ImageViewerView {

    class ViewModel: ObservableObject {

        enum State {
            case images([CGImage])
            case error(String)
            case saving
        }
        @Published var state = State.images([])
        @Published var saveTitle: String = "Save images"
        private let imageManager: ImageReader
        private let imageExporter: ImageExporter

        init(
            imageManager: ImageReader,
            imageExporter: ImageExporter
        ) {
            self.imageManager = imageManager
            self.imageExporter = imageExporter
            imageManager
                .images
                .map {
                    State.images($0)
                }
                .catch {
                    Just(State.error($0.localizedDescription))
                }
                .receive(on: DispatchQueue.main)
                .assign(to: &$state)
        }

        func save(_ images: [CGImage]) {
            guard !images.isEmpty else { return }
            state = .saving
            imageExporter.saveImages(images)
        }
    }
}
