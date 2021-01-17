//
//  DeepBreathApp.swift
//  DeepBreath WatchKit Extension
//
//  Created by Arsenkin Bogdan on 09.01.2021.
//

import SwiftUI

@main
struct DeepBreathApp: App {
    @Environment(\.scenePhase) private var scenePhase
    let calculationModel = CalculationModel()
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            TabView {
                StatisticsView()
                    .environmentObject(calculationModel)
                ContentView()
                    .environmentObject(calculationModel)
                OptionsView()
                    .environmentObject(calculationModel)
            }
        }.onChange(of: scenePhase) { phase in
            if phase == .active {
                calculationModel.updateOptionsStatisticsAndMilestones()
            }
        }
        
        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
