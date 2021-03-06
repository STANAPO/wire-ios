//
// Wire
// Copyright (C) 2017 Wire Swiss GmbH
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see http://www.gnu.org/licenses/.
//


import Foundation


private enum ExtensionSettingsKey: String {

    case fetchLinkPreview = "fetchLinkPreview"

    static var all: [ExtensionSettingsKey] {
        return [.fetchLinkPreview]
    }

    private var defaultValue: Any? {
        switch self {
        case .fetchLinkPreview: return true
        }
    }

    static var defaultValueDictionary: [String: Any] {
        return all.reduce([:]) { result, current in
            var mutableResult = result
            mutableResult[current.rawValue] = current.defaultValue
            return mutableResult
        }
    }

}


private let defaults = UserDefaults.shared()


public class ExtensionSettings: NSObject {

    public static let shared = ExtensionSettings()

    public override class func initialize() {
        super.initialize()
        setupDefaultValues()
    }

    private static func setupDefaultValues() {
        defaults?.register(defaults: ExtensionSettingsKey.defaultValueDictionary)
    }

    public func reset() {
        ExtensionSettingsKey.all.forEach {
            defaults?.removeObject(forKey: $0.rawValue)
        }

        // As we purposely crash afterwards we manually call synchronize.
        defaults?.synchronize()
    }

    public var fetchLinkPreview: Bool {
        get {
            return defaults?.bool(forKey: ExtensionSettingsKey.fetchLinkPreview.rawValue) ?? false
        }

        set {
            defaults?.set(newValue, forKey: ExtensionSettingsKey.fetchLinkPreview.rawValue)
        }
    }

}
