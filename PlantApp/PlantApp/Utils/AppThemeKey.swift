//
//  AppThemeKey.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 24.06.25.
//

import SwiftUI

private struct DarkModeEnabledKey: EnvironmentKey {
    static let defaultValue: Binding<Bool> = .constant(false)
}

extension EnvironmentValues {
    var darkModeEnabled: Binding<Bool> {
        get { self[DarkModeEnabledKey.self] }
        set { self[DarkModeEnabledKey.self] = newValue }
    }
}
