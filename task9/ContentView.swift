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
            .overlay { Color.yellow.frame(width: 300).clipShape(Circle()).blur(radius: 40) }
            .overlay { Color.black
                .overlay { Circle().blendMode(.destinationOut).frame(width: 130)
                    .overlay { Circle().blendMode(.destinationOut).frame(width: 130).offset(offset)
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
                                .onChanged { value in
                                    isDragging = true
                                    offset = value.translation
                                }
                                .onEnded { _ in
                                    isDragging = false
                                    withAnimation(.interpolatingSpring(stiffness: 100, damping: 15)) { offset = .zero }
                                }
                        )
                    }
                }
                .compositingGroup()
            }
            .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
