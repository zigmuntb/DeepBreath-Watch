//
//  DatePickerView.swift
//  DeepBreath WatchKit Extension
//
//  Created by Arsenkin Bogdan on 10.01.2021.
//

import SwiftUI
import UserNotifications
import WatchKit

struct DatePickerView: View {
    @EnvironmentObject var day: CalculationModel
    @Environment(\.presentationMode) var presentationMode
    @State var value: Int = 0
    
    var body: some View {
        VStack {
            Picker(selection: $value, label: Text("Days ago")) {
                ForEach(0 ..< 100) {
                    if $0 == 0 {
                        Text("Today")
                    } else {
                        Text("\($0)")
                    }
                }
            }
            
            Button("Save") {
                checkForUserNotification()
                updateModel()
            }
        }
    }
    
    private func checkForUserNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                setNotification()
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    private func setNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        if value == 0 {
            let titles = ["Heart rate drops to normal!",
                          "Blood pressure and pulse returns to normal!",
                          "Nicotine levels decreased by over 93%!"]
            
            let timeIntervals = [1200, 1210, 28800]
            
            for index in 0 ..< titles.count - 1 {
                let content = UNMutableNotificationContent()
                content.title = titles[index]
                content.sound = .default
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timeIntervals[index]), repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request)
            }
        }
    }
    
    private func updateModel() {
        let dateToSave = value == 0 ? Date() : Calendar.current.date(byAdding: .day, value: -value, to: Date()) ?? Date()
        day.date = dateToSave
        UserDefaults.standard.setValue(dateToSave, forKey: "date")
        day.updateOptionsStatisticsAndMilestones()
        day.updateComplication()
        presentationMode.wrappedValue.dismiss()
    }
}

struct DatePickerView_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerView()
    }
}
