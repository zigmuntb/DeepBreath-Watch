//
//  InitialSetupView.swift
//  DeepBreath WatchKit Extension
//
//  Created by Arsenkin Bogdan on 21.01.2021.
//

import SwiftUI

struct InitialSetupView: View {
    @Binding var rootIsActive : Bool
    
    var body: some View {
        VStack {
            Text("You are making a life changing decision. Be strong and let's begin.")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .minimumScaleFactor(0.01)
                .multilineTextAlignment(.center)
                .gradientForeground(colors: [.blue, .green])
//            Button("Configure") {

                NavigationLink(destination: PriceForPackView(shouldPopToRoot: $rootIsActive)) {
                    Text("Configure")
                }
//            }
        }
    }
}

struct PriceForPackView: View {
    @EnvironmentObject var calculationModel: CalculationModel
    @State var wholeNumber: Int = 0
    @State var decimalNumber: Int = 0
    @Binding var shouldPopToRoot: Bool
    
    var body: some View {
        VStack {
            Text("Enter the cost of a pack")
                .font(.system(size: 14, weight: .semibold, design: .rounded))
            
            Text("Turn the crown to choose")
                .foregroundColor(.gray)
                .font(.system(size: 10, weight: .regular, design: .rounded))
                .minimumScaleFactor(0.01)
            
            
            HStack {
                Picker(selection: $wholeNumber, label: Text("")) {
                    ForEach(0 ..< 1000) {
                        Text("\($0)")
                    }
                }
                
                VStack {
                    Spacer()
                    Text(".")
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                }
                
                Picker(selection: $decimalNumber, label: Text("")) {
                    ForEach(0 ..< 100) {
                        Text("\($0)")
                    }
                }
            }
            Button("Continue") {
                let doubleValue = createDouble()
                UserDefaults.standard.set(doubleValue, forKey: "Price/Pack")
                UserDefaults.standard.setValue(true, forKey: "isSetupFinished")
                print(doubleValue)
                calculationModel.updateOptionsStatisticsAndMilestones()
                shouldPopToRoot = false
            }
        }
    }
    
    private func createDouble() -> Double {
        let stringValue = String(wholeNumber) + "." + String(decimalNumber)
        return Double(stringValue) ?? 0.0
    }
}
