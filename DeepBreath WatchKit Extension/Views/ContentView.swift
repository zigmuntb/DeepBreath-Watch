//
//  ContentView.swift
//  DeepBreath WatchKit Extension
//
//  Created by Arsenkin Bogdan on 09.01.2021.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    @EnvironmentObject var milestones: CalculationModel
    
    var body: some View {
        GeometryReader { geomentry in
            ScrollView {
                VStack {
                    ForEach(milestones.milestones, id: \.id) { item in
                        VStack {
                            Text(item.title)
                                .multilineTextAlignment(.center)
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                                .minimumScaleFactor(0.01)
                            
                            CirclePercentageView(percentage: CGFloat(item.percentage))
                                .frame(width: geomentry.size.width / 1.5, height: geomentry.size.width / 1.5)
                            
                            Text("\(item.explenationText)")
                                .multilineTextAlignment(.center)
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .minimumScaleFactor(0.01)
                            
                            HStack {
                                RoundedRectangle(cornerRadius: 25.0)
                                    .foregroundColor(item.percentage > 0.5 ? .blue : .gray)
                                    .frame(width: 10, height: 10, alignment: .center)
                                
                                RoundedRectangle(cornerRadius: 25.0)
                                    .foregroundColor(item.percentage >= 1 ? .green : .gray)
                                    .frame(width: 10, height: 10, alignment: .center)
                            }
                        }.padding()
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(CalculationModel())
    }
}
