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
        
        // FIRST NOTIFICATION
        let content = UNMutableNotificationContent()
        content.title = "20 minutes! Congratulations!"
        content.subtitle = "Your heart rate and blood pressure decreased and blood circulation started improving."
        content.sound = .default
        
        // show this notification 20 minutes from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1200, repeats: false)
        
        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
        
        // Second NOTIFICATION
        let content1 = UNMutableNotificationContent()
        content1.title = "8 hours! Congratulations!"
        content1.subtitle = "Nicotine levels in your bloodstream decreased by over 93%."
        content1.sound = .default
        
        // show this notification 8 hours from now
        let trigger1 = UNTimeIntervalNotificationTrigger(timeInterval: 28800, repeats: false)
        
        // choose a random identifier
        let request1 = UNNotificationRequest(identifier: UUID().uuidString, content: content1, trigger: trigger1)
        
        // add our notification request
        UNUserNotificationCenter.current().add(request1)
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
