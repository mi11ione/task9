//
//  ContentView.swift
//  task9
//
//  Created by mi11ion on 23/12/24.
//

import SwiftUI

struct ContentView: View {
    @State private var offset = CGSize.zero

    var body: some View {
        ZStack {
            Color.red
            Circle().fill(.yellow).frame(width: 200).blur(radius: 10)

            ZStack {
                Color.black

                Canvas { swag, size in
                    swag.addFilter(.alphaThreshold(min: 0.5, color: .yellow))
                    swag.addFilter(.blur(radius: 18))

                    swag.drawLayer { layer in
                        let circle = Circle().path(in: CGRect(origin: CGPoint(x: (size.width - 130) / 2, y: (size.height - 130) / 2), size: CGSize(width: 130, height: 130)))
                        layer.fill(circle, with: .color(.black))
                        layer.fill(circle.offsetBy(dx: offset.width, dy: offset.height), with: .color(.black))
                    }
                }

                Circle()
                    .fill(.black)
                    .frame(width: 128)
                    .blendMode(.destinationOut)

                Circle()
                    .fill(.black)
                    .frame(width: 128)
                    .offset(offset)
                    .blendMode(.destinationOut)
            }
            .compositingGroup()

            Image(systemName: "cloud.sun.rain.fill")
                .symbolRenderingMode(.hierarchical)
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.white)
                .offset(offset)
                .gesture(
                    DragGesture()
                        .onChanged { offset = $0.translation }
                        .onEnded { _ in withAnimation(.interpolatingSpring(stiffness: 100, damping: 15)) { offset = .zero } }
                )
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
