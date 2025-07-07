//
//  Toast.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 04.07.25.
//

import Foundation
import SwiftUI

struct Toast: Equatable {
  var style: ToastStyle
  var message: String
  var duration: Double = 3
  var width: Double = .infinity
}


enum ToastStyle {
  case error
  case success
}

extension ToastStyle {
  var themeColor: Color {
    switch self {
    case .error: return Color("signalColor")
    case .success: return Color("secondaryPetrol")
    }
  }
  
  var iconFileName: String {
    switch self {
    case .success: return "checkmark.circle.fill"
    case .error: return "xmark.circle.fill"
    }
  }
}
