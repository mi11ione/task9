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
        ZStack {
            Rectangle().fill(.red)
            Circle().fill(.yellow).frame(width: 200).blur(radius: 10)
        }
        .mask {
            CanvasView(offset: $offset)
        }
        .overlay {
            Image(systemName: "cloud.sun.rain.fill")
                .symbolRenderingMode(.hierarchical)
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.white)
                .offset(offset)
        }
        .gesture(DragGesture()
            .onChanged { value in offset = value.translation }
            .onEnded { _ in withAnimation(.interactiveSpring(response: 0.65, dampingFraction: 0.75, blendDuration: 0.8)) { offset = .zero } }
        )
        .background(.black)
        .ignoresSafeArea()
    }
}
