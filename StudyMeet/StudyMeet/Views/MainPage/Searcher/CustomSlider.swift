//
//  CustomSlider.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 14.06.2025.
//
import SwiftUI

import SwiftUI

struct RangeSliderView: View {
    @ObservedObject var viewModel: ViewModel
    @State private var isActive: Bool = false
    let sliderPositionChanged: (ClosedRange<Float>) -> Void

    var body: some View {
        GeometryReader { geometry in
            sliderView(sliderSize: geometry.size,
                       sliderViewYCenter: geometry.size.height / 2)
        }
        .frame(height: 32)
    }

    @ViewBuilder private func sliderView(sliderSize: CGSize, sliderViewYCenter: CGFloat) -> some View {
        // Фоновая линия
        RoundedRectangle(cornerRadius: 2)
            .fill(Color.grayTextSM)
            .frame(height: 4)
            .position(x: sliderSize.width / 2, y: sliderViewYCenter)

        // Активная линия
        Path { path in
            path.move(to: viewModel.leftThumbLocation(width: sliderSize.width,
                                                      sliderViewYCenter: sliderViewYCenter))
            path.addLine(to: viewModel.rightThumbLocation(width: sliderSize.width,
                                                           sliderViewYCenter: sliderViewYCenter))
        }
        .stroke(Color.lightBlueSM, lineWidth: 4)

        // Левый ползунок
        thumbView(position: viewModel.leftThumbLocation(width: sliderSize.width,
                                                        sliderViewYCenter: sliderViewYCenter))
        .highPriorityGesture(DragGesture().onChanged { dragValue in
            let newValue = viewModel.newThumbLocation(dragLocation: dragValue.location, width: sliderSize.width)

            if newValue <= viewModel.sliderPosition.upperBound {
                viewModel.sliderPosition = newValue...viewModel.sliderPosition.upperBound
                sliderPositionChanged(viewModel.sliderPosition)
                isActive = true
            }
        })

        // Правый ползунок
        thumbView(position: viewModel.rightThumbLocation(width: sliderSize.width,
                                                         sliderViewYCenter: sliderViewYCenter))
        .highPriorityGesture(DragGesture().onChanged { dragValue in
            let newValue = viewModel.newThumbLocation(dragLocation: dragValue.location, width: sliderSize.width)

            if newValue >= viewModel.sliderPosition.lowerBound {
                viewModel.sliderPosition = viewModel.sliderPosition.lowerBound...newValue
                sliderPositionChanged(viewModel.sliderPosition)
                isActive = true
            }
        })
    }

    @ViewBuilder func thumbView(position: CGPoint) -> some View {
        Circle()
            .fill(Color.lightBlueSM)
            .frame(width: 24, height: 24)
            .position(position)
            .animation(.easeInOut(duration: 0.2), value: isActive)
    }
}

extension RangeSliderView {
    final class ViewModel: ObservableObject {
        @Published var sliderPosition: ClosedRange<Float>
        let sliderBounds: ClosedRange<Int>
        let sliderBoundDifference: Int

        init(sliderPosition: ClosedRange<Float>, sliderBounds: ClosedRange<Int>) {
            self.sliderPosition = sliderPosition
            self.sliderBounds = sliderBounds
            self.sliderBoundDifference = max(1, sliderBounds.count - 1)
        }

        func stepWidthInPixel(width: CGFloat) -> CGFloat {
            width / CGFloat(sliderBoundDifference)
        }

        func leftThumbLocation(width: CGFloat, sliderViewYCenter: CGFloat) -> CGPoint {
            let offset = CGFloat(sliderPosition.lowerBound - Float(sliderBounds.lowerBound))
            return CGPoint(x: offset * stepWidthInPixel(width: width), y: sliderViewYCenter)
        }

        func rightThumbLocation(width: CGFloat, sliderViewYCenter: CGFloat) -> CGPoint {
            let offset = CGFloat(sliderPosition.upperBound - Float(sliderBounds.lowerBound))
            return CGPoint(x: offset * stepWidthInPixel(width: width), y: sliderViewYCenter)
        }

        func newThumbLocation(dragLocation: CGPoint, width: CGFloat) -> Float {
            let xOffset = min(max(0, dragLocation.x), width)
            let value = Float(sliderBounds.lowerBound) + Float(xOffset / stepWidthInPixel(width: width))
            return min(max(Float(sliderBounds.lowerBound), value), Float(sliderBounds.upperBound))
        }
    }
}
