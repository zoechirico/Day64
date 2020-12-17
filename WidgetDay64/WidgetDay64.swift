//
//  WidgetDay64.swift
//  WidgetDay64
//
//  Created by Mike Chirico on 12/17/20.
//

import WidgetKit
import SwiftUI
import Intents

var counter: Int64 = 0
struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(),txt: "start", configuration: ConfigurationIntent())
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(),txt: "start", configuration: configuration)
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an x time apart, starting from the current date.
        let currentDate = Date()
        for timeOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .second, value: timeOffset, to: currentDate)!
            counter += 1
            let entry = SimpleEntry(date: entryDate,txt: "count: \(counter)", configuration: configuration)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let txt: String
    let configuration: ConfigurationIntent
}

struct WidgetDay64EntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        ZStack {
            Color("ZbackGround")
            VStack{
                Spacer(minLength: 9)
                Text(entry.date, style: .time)
                Spacer(minLength: 50)
                VStack{
                    Spacer(minLength: 12)
                    HStack{
                        ZStack{
                            Color("Z2")
                            Spacer(minLength: 142)
                            Text(entry.date, style: .timer)
                                .padding(.leading)
                                .foregroundColor(.black)
                        }
                    }
                    Spacer(minLength: 12)
                }
                .background(ContainerRelativeShape().fill(Color("Z3")))
                Spacer(minLength: 43)
                Text(entry.txt)
                Spacer(minLength: 10)
            }
        }
    }
}

@main
struct WidgetDay64: Widget {
    let kind: String = "WidgetDay64"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            WidgetDay64EntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct WidgetDay64_Previews: PreviewProvider {
    static var previews: some View {
        WidgetDay64EntryView(entry: SimpleEntry(date: Date(),txt: "start", configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
