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
    @State var leftRectangleWidth: CGFloat = 100
    @State var rightRectangleWidth: CGFloat = 100

    var body: some View {
        ZStack {
            Image("Image")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .blur(radius: 3)
            HStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.clear)
                    .frame(width: leftRectangleWidth, height: 100)
                CustomControl(percentage: $percentage, controlWidth: $controlWidth, controlHeight: $controlHeight, leftRectangleWidth: $leftRectangleWidth, rightRectangleWidth: $rightRectangleWidth)
                    .accentColor(.white)
                    .frame(width: .infinity, height: controlHeight)
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.clear)
                    .frame(width: rightRectangleWidth, height: 100)
            }
            .rotationEffect(.degrees(-90))
        }
    }
}

struct CustomControl: View {
    @Binding var percentage: Float
    @Binding var controlWidth: CGFloat
    @Binding var controlHeight: CGFloat
    @Binding var leftRectangleWidth: CGFloat
    @Binding var rightRectangleWidth: CGFloat
    
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
                            self.rightRectangleWidth = max(0, 100 - extraWidth / 7) // Уменьшение правого прямоугольника
                        } else if value.location.x < 0 {
                            let extraWidth = abs(value.location.x)
                            self.controlHeight = 75 - extraWidth / 20 // Уменьшение высоты
                            self.leftRectangleWidth = max(0, 100 - extraWidth / 7) // Уменьшение левого прямоугольника
                        } else {
                            self.controlHeight = 75
                            self.leftRectangleWidth = 100
                            self.rightRectangleWidth = 100
                        }
                    }
                    .onEnded { _ in
                        // Анимационно сбрасываем высоту и ширину прямоугольников после окончания перетаскивания
                        withAnimation {
                            self.controlHeight = 75
                            self.leftRectangleWidth = 100
                            self.rightRectangleWidth = 100
                        }
                    }
            )
        }
    }
}

#Preview {
    ContentView()
}
