//
//  ContentView.swift
//  Max7456_extractor
//
//  Created by Roman on 16.01.2024.
//

import SwiftUI

struct ContentView: View {

    @ObservedObject var viewModel: ViewModel

    var body: some View {
        VStack {
            FileOpenView(viewModel: viewModel.fileOpen)
            Divider()
            ImageViewerView(viewModel: viewModel.imagesViewer)
        }
        .frame(maxWidth: .infinity)
    }
}

extension ContentView {

    class ViewModel: ObservableObject {

        lazy var fileOpen = FileOpenView.ViewModel(imageManager: imageManager)
        lazy var imagesViewer = ImageViewerView.ViewModel(imageManager: imageManager, imageExporter: .init())
        private let imageManager = ImageReader()
    }
}
