//
//  ContentView.swift
//  task9
//
//  Created by mi11ion on 23/12/24.
//

import SwiftUI

struct ContentView: View {
    @State private var offset: CGSize = .zero
    var body: some View {
        Rectangle().fill(.red)
            .overlay { Circle().fill(.yellow).frame(width: 200).blur(radius: 10) }
            .mask { Metaball(offset: $offset) }
            .overlay {
                Image(systemName: "cloud.sun.rain.fill")
                    .symbolRenderingMode(.hierarchical)
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.white)
                    .offset(offset)
            }
            .gesture(
                DragGesture()
                    .onChanged { value in offset = value.translation }
                    .onEnded { _ in withAnimation(.interactiveSpring(response: 0.65, dampingFraction: 0.75, blendDuration: 0.8)) { offset = .zero } }
            )
            .ignoresSafeArea()
    }
}

private struct Metaball: View {
    @Binding var offset: CGSize

    var body: some View {
        Canvas { swag, size in
            swag.addFilter(.alphaThreshold(min: 0.5, color: .white))
            swag.addFilter(.blur(radius: 32))
            swag.drawLayer { layer in for id in [0, 1] { layer.draw(layer.resolveSymbol(id: id)!, at: CGPoint(x: size.width / 2, y: size.height / 2)) } }
        } symbols: {
            ForEach([0, 1], id: \.self) { id in Circle().frame(width: 150).offset(id == 0 ? offset : .zero).tag(id) }
        }
    }
}
