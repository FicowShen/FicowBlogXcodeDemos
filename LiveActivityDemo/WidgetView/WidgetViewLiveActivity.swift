import ActivityKit
import WidgetKit
import SwiftUI

var startTime = Date.now
var endTime = Date.now.addingTimeInterval(200)
var showCountdownItems = false

struct WidgetViewLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveActivityAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.text)")
                if showCountdownItems {
                    HStack {
                        ProgressView(
                            timerInterval: startTime...endTime,
                            countsDown: true,
                            label: { EmptyView() },
                            currentValueLabel: { EmptyView() }
                        )
                        .tint(Color.red)
                        .progressViewStyle(.circular)
                        Text(timerInterval: startTime...endTime,
                             pauseTime: context.state.pauseTime,
                             countsDown: true,
                             showsHours: false)
                    }
                }
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.text)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.text)")
            } minimal: {
                Text(context.state.text)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension LiveActivityAttributes {
    fileprivate static var preview: LiveActivityAttributes {
        LiveActivityAttributes(id: "Ficow Shen")
    }
}

extension LiveActivityAttributes.ContentState {
    fileprivate static var smiley: LiveActivityAttributes.ContentState {
        LiveActivityAttributes.ContentState(text: "😀")
     }
     
     fileprivate static var starEyes: LiveActivityAttributes.ContentState {
         LiveActivityAttributes.ContentState(text: "🤩")
     }
}

#Preview("Notification", as: .content, using: LiveActivityAttributes.preview) {
   WidgetViewLiveActivity()
} contentStates: {
    LiveActivityAttributes.ContentState.smiley
    LiveActivityAttributes.ContentState.starEyes
}
