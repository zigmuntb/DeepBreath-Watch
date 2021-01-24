//
//  CalculationModel.swift
//  DeepBreath WatchKit Extension
//
//  Created by Arsenkin Bogdan on 09.01.2021.
//

import SwiftUI
import ClockKit

class CalculationModel: ObservableObject {
    @Published var milestones: [Milestone] = []
    @Published var options: [OptionModel] = []
    @Published var date: Date = Date()
    @Published var statistics: [StatisticsModel] = []
    @Published var isSetupFinished: Bool = false
    
    var milestoneNames: [String] = []
    var percentages: [Double] = []
    let timeMilestonesInMinutes: [Double] = [20, 20, 380, 480, 1140, 2880, 2880, 4320, 10080, 20160, 43200, 259200, 518400]
    let optionsNames: [String] = ["Cigarettes/Day", "Cigarettes/Pack", "Price/Pack"]
    let titlesForMilestones: [String] = ["Heart rate", "Blood pressure/Pulse", "Nicotine level", "Oxygen levels", "Risk of heart attack", "Senses", "Nicotine free", "Breathing", "Important milestone", "Psychological effects", "Energy levels", "Cough", "One Year!"]
    var price: Int = 10
    var cigarettesDay: Int = 11
    var cigarettesInPack: Int = 12
    
    let minute20 = "The heart rate drops to normal."
    let minute20Pulse = "Blood pressure and pulse returns to normal."
    let hour8 = "Nicotine levels in your bloodstream decreased by over 93%."
    let hour8oxygen = "Oxygen levels increase, which better nourishes tissues and blood vessels."
    let day1 = "Risk of heart attack will rapidly drop."
    let day2senses = "Sense of smell and taste begin to improve. Also, irritability and anxieties begin to decrease."
    let day2 = "Your body is nicotine free."
    let day3 = "Breathing becomes easier."
    let week1 = "Former smokers who make it to this point are nine times more likely to successfully quit smoking for good."
    let week2 = "Psychological effects of nicotine withdrawal will stop. Your lung function increases 30% at this point."
    let month = "Your overall energy levels improve and smoking-related symptoms decrease."
    let month6 = "Coughing decreases."
    let year = "Risk of heart attack, stroke and coronary heart disease have dropped to half that of a smoker."
    
    init() {
        setupUserDefaults()
        setupMilestones()
        setupOptions()
        setupStatistics()
    }
    
    //MARK: - Setup
    private func setupUserDefaults() {
        registerUserDefaults()
        isSetupFinished = UserDefaults.standard.bool(forKey: "isSetupFinished")
        date = (UserDefaults.standard.object(forKey: "date") as? Date) ?? Date()
        cigarettesDay = UserDefaults.standard.integer(forKey: optionsNames[0])
        cigarettesInPack = UserDefaults.standard.integer(forKey: optionsNames[1])
        price = UserDefaults.standard.integer(forKey: optionsNames[2])
    }
    
    private func registerUserDefaults() {
        UserDefaults.standard.register(defaults: ["isSetupFinished" : false])
        UserDefaults.standard.register(defaults: [optionsNames[2] : 0])
    }
    
    private func setupMilestones() {
        milestoneNames = [minute20, minute20Pulse, hour8, hour8oxygen, day1, day2senses, day2, day3, week1, week2, month, month6, year]
        
        var percentages: [Double] = []
        var milestones: [Milestone] = []
        
        let minutesHavePassed = Double(minutesBetweenDates(date, Date()))
        
        for item in timeMilestonesInMinutes {
            let calculation = minutesHavePassed / item
            percentages.append(calculation)
        }
        
        for number in 0 ... milestoneNames.count - 1 {
            let milestone = Milestone(title: titlesForMilestones[number], percentage: percentages[number], explenationText: milestoneNames[number])
            milestones.append(milestone)
        }
        
        self.milestones = milestones
    }
    
    private func setupOptions() {
        let options = [
            OptionModel(name: optionsNames[0], number: cigarettesDay),
            OptionModel(name: optionsNames[1], number: cigarettesInPack),
            OptionModel(name: optionsNames[2], number: price)
        ]
        self.options = options
    }
    
    private func setupStatistics() {
        let minutesPassedSinceSavedDateToDate = Double(minutesBetweenDates(date, Date()))
        let averageSmokingInMinutes = 1440.0 / Double(cigarettesDay)
        let notSmokedCigarettes = minutesPassedSinceSavedDateToDate / averageSmokingInMinutes
        let daysNotSmoking = minutesPassedSinceSavedDateToDate / 1440.0
        let priceForOneCigarette = Double(price) / Double(cigarettesInPack)
        let moneySaved = priceForOneCigarette * notSmokedCigarettes
        
        let daysNotSmokingModel = StatisticsModel(name: "Days not smoking", amount: daysNotSmoking)
        let notSmokedCigarettesModel = StatisticsModel(name: "Cigarettes not smoked", amount: notSmokedCigarettes)
        let moneySavedModel = StatisticsModel(name: "Money Saved", amount: moneySaved)
        
        let statistics = [daysNotSmokingModel, notSmokedCigarettesModel, moneySavedModel]
        self.statistics = statistics
    }
    
    // Called in PickerView to update data for OptionsView
    func updateOptionsStatisticsAndMilestones() {
        setupUserDefaults()
        setupOptions()
        setupStatistics()
        setupMilestones()
    }
    
    func calculateTimeDifference() -> String {
        let dateStr = "2016-05-27 17:33:43+0400"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ssxx"
        formatter.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        if let date = formatter.date(from: dateStr) {
            print(date)   // "2016-05-27 13:33:00 +0000\n" -4hs
            let dateComponentsFormatter = DateComponentsFormatter()
            dateComponentsFormatter.allowedUnits = [.minute]
            dateComponentsFormatter.unitsStyle = .full
            print(dateComponentsFormatter.string(from: date, to: Date()) ?? "") // 6 days, 17 hours, 51 minutes, 29 seconds
            return dateComponentsFormatter.string(from: date, to: Date()) ?? ""
        }
        return "Error"
    }
    
    func minutesBetweenDates(_ oldDate: Date, _ newDate: Date) -> CGFloat {

        //get both times sinces refrenced date and divide by 60 to get minutes
        let newDateMinutes = newDate.timeIntervalSinceReferenceDate / 60
        let oldDateMinutes = oldDate.timeIntervalSinceReferenceDate / 60
        
        //then return the difference
        return CGFloat(newDateMinutes - oldDateMinutes)
    }
    
    //MARK: - Methods for complication
    func getDaysNotSmokingForComplication(from date: Date) -> String {
        let freshDate = (UserDefaults.standard.object(forKey: "date") as? Date) ?? Date()
        let minutesPassedSinceSavedDateToDate = Double(minutesBetweenDates(freshDate, date))
        let daysNotSmoking = minutesPassedSinceSavedDateToDate / 1440.0
        return String(Int(daysNotSmoking))
    }
    
    func updateComplication() {
        let complicationServer = CLKComplicationServer.sharedInstance()
        
        if let activeComplications = complicationServer.activeComplications {
            for complication in activeComplications {
                // Be selective on what you actually need to reload
                complicationServer.reloadTimeline(for: complication)
            }
        }
    }
}

struct Milestone {
    let id = UUID()
    let title: String
    let percentage: Double
    let explenationText: String
}

struct OptionModel {
    let id = UUID()
    let name: String
    let number: Int
}

struct StatisticsModel {
    let id = UUID()
    let name: String
    let amount: Double
}
