//
//  CanvasView.swift
//  reddit-place
//
//  Created by chuy g on 20/04/22.
//

import SwiftUI

struct CanvasView: View {
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: CanvasViewModel
//    let webView: WebView = WebView(web: nil)
    
    init(viewModel: CanvasViewModel) {
        self.viewModel = viewModel
    }
    
    
    var body: some View {
        if let image = viewModel.image {
            Image(uiImage: image)
                .scaledToFit()
        } else {
            Color.black
        }
    }
    
    // MARK: - Helper Functions
        
}
