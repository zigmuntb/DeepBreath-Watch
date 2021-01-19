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
        
        // First NOTIFICATION
        let content = UNMutableNotificationContent()
        content.title = "Heart rate drops to normal!"
        content.sound = .default
        
        // show this notification 20 minutes from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1200, repeats: false)
        
        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
        
        // Second NOTIFICATION
        let content1 = UNMutableNotificationContent()
        content1.title = "Blood pressure and pulse returns to normal!"
        content1.sound = .default
        
        // show this notification 20 minutes from now
        let trigger1 = UNTimeIntervalNotificationTrigger(timeInterval: 1210, repeats: false)
        
        // choose a random identifier
        let request1 = UNNotificationRequest(identifier: UUID().uuidString, content: content1, trigger: trigger1)
        
        UNUserNotificationCenter.current().add(request1)
        
        // Third NOTIFICATION
        let content2 = UNMutableNotificationContent()
        content2.title = "Nicotine levels decreased by over 93%!"
        content2.sound = .default
        
        // show this notification 8 hours from now
        let trigger2 = UNTimeIntervalNotificationTrigger(timeInterval: 28800, repeats: false)
        
        // choose a random identifier
        let request2 = UNNotificationRequest(identifier: UUID().uuidString, content: content2, trigger: trigger2)
        
        // add our notification request
        UNUserNotificationCenter.current().add(request2)
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
