//
//  CanvasView.swift
//  reddit-place
//
//  Created by chuy g on 20/04/22.
//

import SwiftUI

struct CanvasView: View {
    
    // MARK: - Properties
    
    @StateObject var viewModel = CanvasViewModel()
    
    var body: some View {
        if let image = viewModel.image {
            Image(uiImage: image)
                .resizable()
        } else {
            Color.black
        }
    }
}
