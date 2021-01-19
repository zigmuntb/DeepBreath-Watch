//
//  StatisticsView.swift
//  DeepBreath WatchKit Extension
//
//  Created by Arsenkin Bogdan on 10.01.2021.
//

import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var statistics: CalculationModel
    
    var body: some View {
        VStack {
            List(statistics.statistics, id: \.id) { item in
                Spacer()
                VStack(alignment: .center) {
                    Text(item.name)
                        .scaledToFit()
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .minimumScaleFactor(0.01)
                    if item.name == "Money Saved" {
                        Text(String(format: "%.2f", item.amount))
                            .scaledToFit()
                            .font(.system(size: 80, weight: .bold, design: .rounded))
                            .minimumScaleFactor(0.01)
                            .gradientForeground(colors: [.blue, .green])
                    } else {
                        Text("\(Int(item.amount.isNaN ? 0 : item.amount))")
                            .scaledToFit()
                            .font(.system(size: 80, weight: .bold, design: .rounded))
                            .minimumScaleFactor(0.01)
                            .gradientForeground(colors: [.blue, .green])
                    }
                }
                Spacer()
            }
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
            .environmentObject(CalculationModel())
    }
}

extension View {
    public func gradientForeground(colors: [Color]) -> some View {
        self.overlay(LinearGradient(gradient: .init(colors: colors),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing))
            .mask(self)
    }
}
