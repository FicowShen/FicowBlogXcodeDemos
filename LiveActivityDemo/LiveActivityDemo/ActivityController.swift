import Foundation
import ActivityKit
import os.activity

enum ActivityWidgetDismissalPolicy {
    case `default`, immediate, after(_ date: Date)
}

final class ActivityController {

    enum LiveActivityError: Error {
        case liveActivitiesNotSupported
    }

    private struct CachedState {
        let state: LiveActivityAttributes.ContentState
        let staleDate: Date?
        let alert: (title: String, body: String)?
    }

    static let shared = ActivityController()
    private var currentActivity: Activity<LiveActivityAttributes>?

    private var latestCachedState: CachedState?

    func restoreLiveActivity() {
        for activity in Activity<LiveActivityAttributes>.activities {
            os_log(.debug, "!!!!! restoreLiveActivity,\nid:\(activity.id)\ncontent: \(activity.content)")
        }
    }

    func startLiveActivity(
        attributes: LiveActivityAttributes,
        initialState: LiveActivityAttributes.ContentState,
        staleDate: Date? = nil,
        relevanceScore: Double = 0
    ) {
        do {
            // https://engineering.monstar-lab.com/en/post/2022/09/30/Live-Activities/
            // 1. Check if device supports Live Activities and that they are enabled
            guard ActivityAuthorizationInfo().areActivitiesEnabled else {
                throw LiveActivityError.liveActivitiesNotSupported
            }
            // 2. Cancel running activities of type `Attributes`
            let finalContent = ActivityContent(state: initialState, staleDate: nil)
            for activity in Activity<LiveActivityAttributes>.activities {
                Task { @MainActor in
                    await activity.end(finalContent, dismissalPolicy: .immediate)
                    os_log(.debug, "!!!!! activity.end,\nid:\(activity.id)\ncontent: \(activity.content)")
                }
            }
            // pushType: .token, reports error: SessionCore.PermissionsError
            // https://developer.apple.com/forums/thread/712223
            let activity = try Activity.request(
                attributes: attributes,
                content: .init(state: initialState, staleDate: staleDate, relevanceScore: relevanceScore),
                pushType: nil
            )

            os_log("%@", type: .debug, "!!!!! startLiveActivity\nattributes:\(attributes)\nstate: \(initialState)\nstaleDate:\(staleDate)\nalert:\(relevanceScore)")
            self.currentActivity = activity
            observeUpdates(activity: activity)
            if let cached = latestCachedState {
                self.latestCachedState = nil
                Task { @MainActor in
                    try await updateActivity(state: cached.state, staleDate: cached.staleDate, alert: cached.alert)
                }
            }
        } catch let error as ActivityAuthorizationError {
#warning("TODO: 处理ActivityAuthorizationError各种错误场景")
//            switch error {
//            case .attributesTooLarge:
//                <#code#>
//            case .unsupported:
//                <#code#>
//            case .denied:
//                <#code#>
//            case .globalMaximumExceeded:
//                <#code#>
//            case .targetMaximumExceeded:
//                <#code#>
//            case .unsupportedTarget:
//                <#code#>
//            case .visibility:
//                <#code#>
//            case .persistenceFailure:
//                <#code#>
//            case .missingProcessIdentifier:
//                <#code#>
//            case .unentitled:
//                <#code#>
//            case .malformedActivityIdentifier:
//                <#code#>
//            case .reconnectNotPermitted:
//                <#code#>
//            }
            os_log("%@", type: .error, "ActivityAuthorizationError: \(error.localizedDescription)")
        } catch {
            let errorMessage = """
            !!!!! Couldn't start activity
            ------------------------
            \(String(describing: error))
            """
#warning("TODO: 处理非ActivityAuthorizationError的错误场景")
            os_log("%@", type: .error, errorMessage)
        }
    }

    func observeUpdates(activity: Activity<LiveActivityAttributes>) {
        Task {
            await withTaskGroup(of: Void.self) { group in
                group.addTask { @MainActor in
                    for await enabled in ActivityAuthorizationInfo().activityEnablementUpdates {
                        os_log("%@", type: .debug, "activityEnablementUpdates: \(enabled)")
                    }
                }
                group.addTask { @MainActor in
                    for await activity in Activity<LiveActivityAttributes>.activityUpdates {
                        os_log("%@", type: .debug, "activityUpdates: \(activity.attributes)")
                    }
                }

                group.addTask { @MainActor in
                    for await activityState in activity.activityStateUpdates {
                        os_log("%@", type: .debug, "activityStateUpdates: \(activity), \(activityState)")
                        if activityState == .dismissed {
//                            self.cleanUpDismissedActivity()
                            os_log(.debug, "activity dismissed")
                        } else {
//                            self.activityViewState?.activityState = activityState
                        }
                    }
                }

                group.addTask { @MainActor in
                    for await contentState in activity.contentUpdates {
                        os_log("%@", type: .debug, "contentUpdates: \(activity), \(contentState)")
//                        self.activityViewState?.contentState = contentState.state
                    }
                }

                group.addTask { @MainActor in
                    for await pushToken in activity.pushTokenUpdates {
                        let pushTokenString = pushToken.hexadecimalString

                        Logger().debug("New push token: \(pushTokenString)")

                        do {
                            let frequentUpdateEnabled = ActivityAuthorizationInfo().frequentPushesEnabled

                            try await self.sendPushToken(id: activity.id,
                                                         pushTokenString: pushTokenString,
                                                         frequentUpdateEnabled: frequentUpdateEnabled)
                        } catch {
                            let errorMessage = """
                                                Failed to send push token to server
                                                ------------------------
                                                \(String(describing: error))
                                                """
                            os_log("%@", type: .error, "pushTokenUpdates: \(activity), \(errorMessage)")
                            #warning("TODO: 处理pushTokenUpdates错误场景")
                        }
                    }
                }
            }
        }
    }

    func updateActivity(
        state: LiveActivityAttributes.ContentState,
        staleDate: Date? = nil,
        alert: (title: String, body: String)? = nil
    ) async throws {

        try await Task.sleep(for: .seconds(1))

        guard let activity = currentActivity else {
            os_log(.debug, "!!!!! no currentActivity")
            latestCachedState = .init(state: state, staleDate: staleDate, alert: alert)
            return
        }
        latestCachedState = nil

        os_log("%@", type: .debug, "!!!!! updateActivity\nstate: \(state)\nstaleDate:\(staleDate)\nalert:\(alert)")
        Task { @MainActor in
            var alertConfig: AlertConfiguration?
            if let alert {
                alertConfig = AlertConfiguration(
                    title: LocalizedStringResource(stringLiteral: alert.title),
                    body: LocalizedStringResource(stringLiteral: alert.body),
                    sound: .default
                )
            }
            await activity.update(
                ActivityContent<LiveActivityAttributes.ContentState>(
                    state: state,
                    staleDate: staleDate,
                    relevanceScore: alertConfig != nil ? 100 : 50
                ),
                alertConfiguration: alertConfig
            )
        }
    }

    func endActivity(finalState: LiveActivityAttributes.ContentState, dismissalPolicy: ActivityWidgetDismissalPolicy) {
        guard let activity = currentActivity else {
            os_log(.debug, "!!!!! no currentActivity")
            return
        }
        os_log("%@", type: .debug, "!!!!! endActivity\nfinalState: \(finalState)\ndismissalPolicy:\(dismissalPolicy)")

        let policy: ActivityUIDismissalPolicy
        switch dismissalPolicy {
        case .default: policy = .default
        case .immediate: policy = .immediate
        case .after(let date): policy = .after(date)
        }
        Task { @MainActor in
            await activity.end(ActivityContent(state: finalState, staleDate: finalState.endTime), dismissalPolicy: policy)
        }
    }
}

private extension ActivityController {
    func sendPushToken(id: String, pushTokenString: String, frequentUpdateEnabled: Bool = false) async throws {
        // 处理推送相关的逻辑
    }
}

private extension Data {
    var hexadecimalString: String {
        self.reduce("") {
            $0 + String(format: "%02x", $1)
        }
    }
}
