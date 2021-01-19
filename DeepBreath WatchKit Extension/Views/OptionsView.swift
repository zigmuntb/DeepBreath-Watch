//
//  OptionsView.swift
//  DeepBreath WatchKit Extension
//
//  Created by Arsenkin Bogdan on 09.01.2021.
//

import SwiftUI

struct OptionsView: View {
    @EnvironmentObject var options: CalculationModel
    @State private var didChangeDate: Bool = false
    @State private var date = ""
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Date of quitting")) {
                    NavigationLink(destination: DatePickerView()) {
                        Text("\(date)")
                            .font(.headline)
                    }.onReceive(options.$date, perform: { _ in
                        formatDate()
                    })
                }
                Section(header: Text("Options")) {
                    ForEach(options.options, id: \.id) { model in
                        NavigationLink(destination: PickerView(value: model.number, title: model.name)) {
                            VStack {
                                Text("\(model.name) - \(model.number)")
                                    .font(.headline)
                            }
                        }
                    }
                }
            }
        }.onAppear() {
            formatDate()
        }
    }
    
    private func formatDate() {
        let currentDate = "d MMMM yyyy"
        let formatter = DateFormatter()
        formatter.dateFormat = currentDate
        date = formatter.string(from: options.date)
    }
}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView()
            .environmentObject(CalculationModel())
    }
}
