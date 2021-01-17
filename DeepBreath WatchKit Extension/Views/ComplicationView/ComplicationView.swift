//
//  ComplicationView.swift
//  DeepBreath WatchKit Extension
//
//  Created by Arsenkin Bogdan on 13.01.2021.
//

import SwiftUI
import ClockKit

struct ComplicationView: View {
    var body: some View {
        Text("Hello, World!")
    }
}

struct ComplicationView_Previews: PreviewProvider {
    static var previews: some View {
        CLKComplicationTemplateModularSmallSimpleText(textProvider: CLKTextProvider(format: "9d"))
            .previewContext()
    }
}
