//
//  ComplicationController.swift
//  DeepBreath WatchKit Extension
//
//  Created by Arsenkin Bogdan on 09.01.2021.
//

import ClockKit
import WatchKit

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Complication Configuration
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward])
    }
    
    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        let descriptors = [
            CLKComplicationDescriptor(identifier: "complication", displayName: "DeepBreath", supportedFamilies: [CLKComplicationFamily.circularSmall, CLKComplicationFamily.modularSmall, CLKComplicationFamily.graphicCorner])
            // Multiple complication support can be added here with more descriptors
        ]
        
        // Call the handler with the currently supported complication descriptors
        handler(descriptors)
    }
    
    func handleSharedComplicationDescriptors(_ complicationDescriptors: [CLKComplicationDescriptor]) {
        // Do any necessary work to support these newly shared complication descriptors
    }
    
    // MARK: - Timeline Configuration
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        // Call the handler with the last entry date you can currently provide or nil if you can't support future timelines
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        // Call the handler with your desired behavior when the device is locked
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        if let template = getComplication(for: complication, using: Date()) {
            let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(entry)
        } else {
            handler(nil)
        }
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after the given date
        handler(nil)
    }
    
    // MARK: - Sample Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        let template = getTemplateForComplication(for: complication)
        if let template = template {
            handler(template)
        } else {
            handler(nil)
        }
    }
    
    func getComplication(for complication: CLKComplication, using date: Date) -> CLKComplicationTemplate? {
        let days = CalculationModel().getDaysNotSmokingForComplication(from: date) + "d"
        switch complication.family {
        case .circularSmall:
            return CLKComplicationTemplateCircularSmallSimpleText(textProvider: CLKTextProvider(format: days))
        case .modularSmall:
            return CLKComplicationTemplateModularSmallSimpleText(textProvider: CLKTextProvider(format: days))
        case .graphicCorner:
            return CLKComplicationTemplateGraphicCornerStackText(innerTextProvider: CLKTextProvider(format: "Smoke free"), outerTextProvider: CLKTextProvider(format: days))
        default:
            return nil
        }
    }
    
    func getTemplateForComplication(for complication: CLKComplication) -> CLKComplicationTemplate? {
        switch complication.family {
        case .circularSmall:
            return CLKComplicationTemplateCircularSmallSimpleText(textProvider: CLKTextProvider(format: "68d"))
        case .modularSmall:
            return CLKComplicationTemplateModularSmallSimpleText(textProvider: CLKTextProvider(format: "68d"))
        case .graphicCorner:
            return CLKComplicationTemplateGraphicCornerStackText(innerTextProvider: CLKTextProvider(format: "Smoke free"), outerTextProvider: CLKTextProvider(format: "68"))
        default:
            return nil
        }
    }
}

