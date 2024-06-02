//
//  AsyncStream+Extensions.swift
//  Pomodoro
//
//  Created by Ficow on 2024/1/25.
//  Copyright © 2024 ficow. All rights reserved.
//

import Foundation
import Observation

extension AsyncStream {
    /// Tracking with async stream
    /// https://nilcoalescing.com/blog/AsyncStreamFromWithObservationTrackingFunc/
    /// - Parameters:
    ///   - apply: observed property
    ///   - queue: observe the change in a aync way, default to .main queue
    /// - Returns: async stream
    static func withObservationTracking(
        _ apply: @escaping () -> Element,
        queue: DispatchQueue = .main
    ) -> AsyncStream<Element> {
        AsyncStream { continuation in
            @Sendable func observe() {
                let change = Observation.withObservationTracking {
                    apply()
                } onChange: {
                    queue.async {
                        observe()
                    }
                }
                continuation.yield(change)
            }
            observe()
        }
    }

    static func observeOnMainActor(
        _ apply: @escaping () -> Element,
        newValue: @escaping (Element) -> Void
    ) {
        Task { @MainActor in
            let changes = AsyncStream.withObservationTracking {
                apply()
            }
            for await change in changes {
                newValue(change)
            }
        }
    }

    static func observeOnMainActor(
        _ apply: @escaping () -> Element,
        stream: @escaping (AsyncStream<Element>) async -> Void
    ) {
        Task { @MainActor in
            let changes = AsyncStream.withObservationTracking {
                apply()
            }
            await stream(changes)
        }
    }
}
