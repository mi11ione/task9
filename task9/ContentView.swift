//
//  ContentView.swift
//  task9
//
//  Created by mi11ion on 23/12/24.
//

import SwiftUI

struct ContentView: View {
    @State private var offset: CGSize = .zero
    @State private var isDragging = false

    var body: some View {
        Color.red
            .overlay {
                GeometryReader { proxy in
                    let size = proxy.size

                    Canvas { context, size in
                        context.addFilter(.alphaThreshold(min: 0.5))
                        context.addFilter(.blur(radius: 12))

                        context.drawLayer { ctx in
                            if let resolvedView = context.resolveSymbol(id: 0) {
                                ctx.draw(resolvedView, at: .init(x: size.width / 2, y: size.height / 2))
                            }
                        }
                    } symbols: {
                        CirclesShape(offset: offset, size: size)
                            .tag(0)
                            .id(0)
                    }
                }
                .overlay {
                    Image(systemName: "cloud.sun.rain.fill")
                        .symbolRenderingMode(.hierarchical)
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.white)
                        .offset(offset)
                        .allowsHitTesting(false)
                }
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            isDragging = true
                            offset = value.translation
                        }
                        .onEnded { _ in
                            isDragging = false
                            withAnimation(.interpolatingSpring(stiffness: 100, damping: 15)) {
                                offset = .zero
                            }
                        }
                )
            }
            .ignoresSafeArea()
    }
}

struct CirclesShape: Shape {
    var offset: CGSize
    var size: CGSize

    func path(in _: CGRect) -> Path {
        let circleRadius: CGFloat = 65
        let distance = sqrt(pow(offset.width, 2) + pow(offset.height, 2))
        let progress = min(1, distance / 100)

        var path = Path()

        path.addEllipse(in: CGRect(x: size.width / 2 - circleRadius,
                                   y: size.height / 2 - circleRadius,
                                   width: circleRadius * 2,
                                   height: circleRadius * 2))

        path.addEllipse(in: CGRect(x: size.width / 2 - circleRadius + offset.width,
                                   y: size.height / 2 - circleRadius + offset.height,
                                   width: circleRadius * 2,
                                   height: circleRadius * 2))

        if distance > 0 {
            let cp1 = CGPoint(x: size.width / 2, y: size.height / 2)
            let cp2 = CGPoint(x: size.width / 2 + offset.width,
                              y: size.height / 2 + offset.height)

            let angle = atan2(offset.height, offset.width)
            let cpd = circleRadius * 0.5 * (1 - progress)

            let controlPoint1 = CGPoint(
                x: cp1.x + cos(angle + .pi / 2) * cpd,
                y: cp1.y + sin(angle + .pi / 2) * cpd
            )

            let controlPoint2 = CGPoint(
                x: cp2.x + cos(angle + .pi / 2) * cpd,
                y: cp2.y + sin(angle + .pi / 2) * cpd
            )

            let controlPoint3 = CGPoint(
                x: cp1.x + cos(angle - .pi / 2) * cpd,
                y: cp1.y + sin(angle - .pi / 2) * cpd
            )

            let controlPoint4 = CGPoint(
                x: cp2.x + cos(angle - .pi / 2) * cpd,
                y: cp2.y + sin(angle - .pi / 2) * cpd
            )

            path.move(to: controlPoint1)
            path.addCurve(to: controlPoint2,
                          control1: CGPoint(x: controlPoint1.x + cos(angle) * distance / 3,
                                            y: controlPoint1.y + sin(angle) * distance / 3),
                          control2: CGPoint(x: controlPoint2.x - cos(angle) * distance / 3,
                                            y: controlPoint2.y - sin(angle) * distance / 3))

            path.addLine(to: controlPoint4)

            path.addCurve(to: controlPoint3,
                          control1: CGPoint(x: controlPoint4.x - cos(angle) * distance / 3,
                                            y: controlPoint4.y - sin(angle) * distance / 3),
                          control2: CGPoint(x: controlPoint3.x + cos(angle) * distance / 3,
                                            y: controlPoint3.y + sin(angle) * distance / 3))
        }

        return path
    }
}

#Preview {
    ContentView()
}
