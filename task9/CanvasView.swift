//
//  CanvasView.swift
//  task9
//
//  Created by mi11ion on 27/12/24.
//

import SwiftUI

struct CanvasView: View {
    @Binding var offset: CGSize

    var body: some View {
        Canvas { context, size in
            context.addFilter(.alphaThreshold(min: 0.5, color: .yellow))
            context.addFilter(.blur(radius: 32))

            context.drawLayer { layer in
                drawSymbols(in: layer, size: size)
            }
        } symbols: {
            Ball()
                .tag(1)
            Ball(offset: offset)
                .tag(2)
        }
    }

    private func drawSymbols(in layer: GraphicsContext, size: CGSize) {
        for id in [1, 2] {
            if let resolved = layer.resolveSymbol(id: id) {
                layer.draw(resolved, at: CGPoint(x: size.width / 2, y: size.height / 2))
            }
        }
    }
}

private struct Ball: View {
    var offset: CGSize = .zero

    var body: some View {
        Circle()
            .fill(.white)
            .frame(width: 150)
            .offset(offset)
    }
}
