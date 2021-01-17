//
//  CirclePercentageView.swift
//  DeepBreath WatchKit Extension
//
//  Created by Arsenkin Bogdan on 09.01.2021.
//

import SwiftUI

struct CirclePercentageView: View {
    @State private var viewIsShown: Bool = false
    
    var percentage: CGFloat
    
    var body: some View {
        VStack() {
            ZStack {
                Circle()
                    .stroke(Color(.gray), style: StrokeStyle(lineWidth: 3, lineCap: .round))
                
                Circle()
                    .trim(from: 0, to: viewIsShown ? (percentage > 1 ? 1.00 : percentage) : 0)
                    .rotation(.degrees(90))
                    .stroke(LinearGradient(gradient: Gradient(colors: [.blue, .green]), startPoint: .leading, endPoint: .trailing), style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .animation(Animation.easeInOut(duration: 4.0))
                    

                VStack(spacing: -10) {
                    LabelView(percentage: percentage)
                    
                    Text("%")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(.gray)
                        .onAppear() {
                            viewIsShown = true
                        }
                }
            }
        }
    }
}

struct LabelView: View {
    let percentage: CGFloat
    
    var body: some View {
        Text("\(Int((percentage > 1 ? 1.00 : percentage) * 100))")
            .font(.system(size: 60, weight: .bold, design: .rounded))
            .foregroundColor(.white)
    }
}

struct CirclePercentageView_Previews: PreviewProvider {
    static var previews: some View {
        CirclePercentageView(percentage: 0.8)
    }
}
