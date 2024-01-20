//
//  FileOpenView.swift
//  Max7456_extractor
//
//  Created by Roman on 20.01.2024.
//

import SwiftUI

struct FileOpenView: View {

    @ObservedObject var viewModel: ViewModel

    var body: some View {
        HStack {
            Text(viewModel.title)
            Button(viewModel.buttonTitle)
            {
                viewModel.selectFileTap()
            }
            .padding()
        }
    }
}

import Combine

extension FileOpenView {

    class ViewModel: ObservableObject {
        @Published var title: String = "no file selected"
        @Published var buttonTitle: String = "Select File"

        private let imageManager: ImageReader

        init(imageManager: ImageReader) {
            self.imageManager = imageManager
        }

        func selectFileTap() {
            let panel = NSOpenPanel()
            panel.allowsMultipleSelection = false
            panel.canChooseDirectories = false
            panel.allowedContentTypes = [.init(filenameExtension: "mcm")!]
            panel.begin { response in
                guard response == .OK, let url = panel.url else {
                    return
                }
                self.title = url.lastPathComponent

                self.imageManager.url.send(url)
            }
        }
    }
}
