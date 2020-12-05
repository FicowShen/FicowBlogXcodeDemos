import Foundation

enum AppEnvironment {
    case debug
    case release
    case appStore

    static var current: Self {
        #if DEBUG_CONFIG
            return .debug
        #elseif RELEASE_CONFIG
            return .release
        #elseif APPSTORE_CONFIG
            return .appStore
        #else
            fatalError("No valid configuration for current scheme!")
        #endif
    }
}
