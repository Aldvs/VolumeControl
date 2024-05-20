//
//  ContentView.swift
//  VolumeControl
//
//  Created by admin on 20.05.2024.
//

import SwiftUI

struct ContentView: View {
    @State var percentage: Float = 50

    var body: some View {
        ZStack {
            Image("Image")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .blur(radius: 3)
            CustomControl(percentage: $percentage)
                .accentColor(.white)
                .frame(width: 275, height: 75)
                .rotationEffect(.degrees(-90))
        }
    }
}

struct CustomControl: View {
    @Binding var percentage: Float // or some value binded

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .background(.ultraThinMaterial)
                Rectangle()
                    .foregroundColor(.accentColor)
                    .frame(width: geometry.size.width * CGFloat(self.percentage / 100))
            }
            .cornerRadius(20)
            .gesture(DragGesture(minimumDistance: 0)
                .onChanged({ value in
                    // TODO: - maybe use other logic here
                    self.percentage = min(max(0, Float(value.location.x / geometry.size.width * 100)), 100)
                }))
        }
    }
}

#Preview {
    ContentView()
}
