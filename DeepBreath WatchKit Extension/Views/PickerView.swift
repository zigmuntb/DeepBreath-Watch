//
//  PickerView.swift
//  DeepBreath WatchKit Extension
//
//  Created by Arsenkin Bogdan on 09.01.2021.
//

import SwiftUI

struct PickerView: View {
    @EnvironmentObject var model: CalculationModel
    @Environment(\.presentationMode) var presentationMode
    @State var value: Int
    
    let title: String
    
    var body: some View {
        VStack {
            Picker(selection: $value, label: Text(title)) {
                ForEach(0 ..< 1000) {
                    Text("\($0)")
                }
            }
            
            Button("Save") {
                UserDefaults.standard.set(value, forKey: title)
                model.updateOptionsStatisticsAndMilestones()
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct PickerView_Previews: PreviewProvider {
    static var previews: some View {
        PickerView(value: 43, title: "Cigarettes in a day")
    }
}
