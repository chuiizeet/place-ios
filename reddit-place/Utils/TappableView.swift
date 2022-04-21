//
//  TappableView.swift
//  reddit-place
//
//  Created by chuy g on 21/04/22.

// https://stackoverflow.com/a/58958770
/*
 .overlay(
     TappableView { gesture in
         // Just use the regular UIKit gesture as you want!
 })
 */

import SwiftUI
import UIKit

struct TappableView: UIViewRepresentable
{
    var tapCallback: (UITapGestureRecognizer) -> Void

    typealias UIViewType = UIView

    func makeCoordinator() -> TappableView.Coordinator
    {
        Coordinator(tapCallback: self.tapCallback)
    }

    func makeUIView(context: UIViewRepresentableContext<TappableView>) -> UIView
    {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(sender:))))
        return view
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<TappableView>)
    {
    }

    class Coordinator
    {
        var tapCallback: (UITapGestureRecognizer) -> Void

        init(tapCallback: @escaping (UITapGestureRecognizer) -> Void)
        {
            self.tapCallback = tapCallback
        }

        @objc func handleTap(sender: UITapGestureRecognizer)
        {
            self.tapCallback(sender)
        }
    }
}
