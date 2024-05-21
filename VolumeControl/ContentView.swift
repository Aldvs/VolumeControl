//
//  ContentView.swift
//  VolumeControl
//
//  Created by admin on 20.05.2024.
//

import SwiftUI

struct ContentView: View {
    @State var percentage: Float = 50
    @State var controlWidth: CGFloat = 300
    @State var controlHeight: CGFloat = 75

    var body: some View {
        ZStack {
            Image("Image")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .blur(radius: 3)
            CustomControl(percentage: $percentage, controlWidth: $controlWidth, controlHeight: $controlHeight)
                            .accentColor(.white)
                            .rotationEffect(.degrees(-90))
                            .frame(width: controlWidth, height: controlHeight)
        }
    }
}

struct CustomControl: View {
    @Binding var percentage: Float
    @Binding var controlWidth: CGFloat
    @Binding var controlHeight: CGFloat
    
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
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let dragPercentage = min(max(0, Float(value.location.x / geometry.size.width * 100)), 100)
                        self.percentage = dragPercentage
                        
                        // Изменяем высоту пропорционально положению перетаскивания
                        if value.location.x > self.controlWidth {
                            let extraWidth = value.location.x - self.controlWidth
                            self.controlHeight = 75 - extraWidth / 20 // Уменьшение высоты
                        } else if value.location.x < 0 {
                            let extraWidth = abs(value.location.x)
                            self.controlHeight = 75 - extraWidth / 20 // Уменьшение высоты
                        } else {
                            self.controlHeight = 75
                        }
                    }
                    .onEnded { _ in
                        // Анимационно сбрасываем высоту после окончания перетаскивания
                        withAnimation {
                            self.controlHeight = 75
                        }
                    }
            )
        }
    }
}

#Preview {
    ContentView()
}
