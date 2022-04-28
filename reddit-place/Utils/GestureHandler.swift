//
//  GestureHandler.swift
//  reddit-place
//
//  Created by chuy g on 19/04/22.
//

import SwiftUI

final class GestureHandler: ObservableObject {
    @Published var scaleAnchor: UnitPoint = .center
    @Published var scale: Double = 0.25
    @Published var offset: CGSize = .zero
    @Published private var baseScale: Double = 1
    @Published private var newOffset: CGSize = .zero
    
    private var minimumScale: Double = 0.235
    private var initScale: Double = 0.25

    private func edgeWidth(x: Double) -> Double {
        let marginW = DeviceUtil.absWindowW * (scale - 1) / 2
        let leadingMargin = scaleAnchor.x / 0.5 * marginW
        let trailingMargin = (1 - scaleAnchor.x) / 0.5 * marginW
        return min(max(x, -trailingMargin), leadingMargin)
    }
    private func edgeHeight(y: Double) -> Double {
        let marginH = DeviceUtil.absWindowH * (scale - 1) / 2
        let topMargin = scaleAnchor.y / 0.5 * marginH
        let bottomMargin = (1 - scaleAnchor.y) / 0.5 * marginH
        return min(max(y, -bottomMargin), topMargin)
    }
    private func correctOffset() {
        offset.width = edgeWidth(x: offset.width)
        offset.height = edgeHeight(y: offset.height)
    }
    private func correctScaleAnchor(point: CGPoint) {
        let x = min(1, max(0, point.x / DeviceUtil.absWindowW))
        let y = min(1, max(0, point.y / DeviceUtil.absWindowH))
        scaleAnchor = .init(x: x, y: y)
    }
    private func setOffset(_ offset: CGSize) {
        self.offset = offset
        correctOffset()
    }
    private func setScale(scale: Double, maximum: Double) {
        guard scale >= minimumScale && scale <= maximum else { return }
        self.scale = scale
    }
    
    func plusScale(scale: Double, maximum: Double) {
        setScale(scale: scale, maximum: maximum)
    }

    func onSingleTapGestureEnded(
//        readingDirection: ReadingDirection,
//        setPageIndexOffsetAction: @escaping (Int) -> Void,
//        toggleShowsPanelAction: @escaping () -> Void
    ) {
//        Logger.info("onSingleTapGestureEnded", context: ["readingDirection": readingDirection])
//        guard readingDirection != .vertical,
//              let pointX = TouchHandler.shared.currentPoint?.x
//        else {
//            toggleShowsPanelAction()
//            return
//        }
//        let rightToLeft = readingDirection == .rightToLeft
//        if pointX < DeviceUtil.absWindowW * 0.15 {
//            setPageIndexOffsetAction(rightToLeft ? 1 : -1)
//        } else if pointX > DeviceUtil.absWindowW * (1 - 0.15) {
//            setPageIndexOffsetAction(rightToLeft ? -1 : 1)
//        } else {
//            toggleShowsPanelAction()
//        }
    }
    
    func reset() {
        offset = .zero
        setScale(scale: initScale, maximum: 1.0)
    }

    func onDoubleTapGestureEnded(scaleMaximum: Double, doubleTapScale: Double) {
        let newScale = scale == 1 ? doubleTapScale : 1
        if let point = TouchHandler.shared.currentPoint {
            correctScaleAnchor(point: point)
        }
        setOffset(.zero)
        setScale(scale: newScale, maximum: scaleMaximum)
    }

    func onMagnificationGestureChanged(value: Double, scaleMaximum: Double) {
        setScale(scale: value * baseScale, maximum: scaleMaximum)
    }

    func onMagnificationGestureEnded(value: Double, scaleMaximum: Double) {
        onMagnificationGestureChanged(value: value, scaleMaximum: scaleMaximum)
//        if value * baseScale - 1 < 0.01 {
//            setScale(scale: 1, maximum: scaleMaximum)
//        }
//        baseScale = scale
    }

    func onDragGestureChanged(value: DragGesture.Value) {
        guard scale > 1 else { return }
        // Velocity between 2 - 5
//        let velocity: CGFloat = 2.5
        let newX = (value.translation.width) + newOffset.width
        let newY = (value.translation.height) + newOffset.height
        let newOffsetW = edgeWidth(x: newX)
        let newOffsetH = edgeHeight(y: newY)
        setOffset(.init(width: newOffsetW, height: newOffsetH))
    }

    func onDragGestureEnded(value: DragGesture.Value) {
        onDragGestureChanged(value: value)
        if scale > 1 {
            newOffset.width = offset.width
            newOffset.height = offset.height
        }
    }

    func onControlPanelDismissGestureEnded(value: DragGesture.Value, dismissAction: @escaping () -> Void) {
        if value.predictedEndTranslation.height > 30 {
            dismissAction()
        }
    }
}
