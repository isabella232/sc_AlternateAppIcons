/*
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

enum AppIcon {
  case primary
  case valentine
  case christmas
  case thanksgiving
  
  enum AlternateError: Error {
    case noAlternateToday
  }
  
  static var current: AppIcon {
    return [
      primary,
      valentine,
      christmas,
      thanksgiving
    ].first{$0.name == UIApplication.shared.alternateIconName}!
  }
  
  /// Alternate between the primary app icon and today's Easter egg
  static func alternate(
    processGetIcon: @escaping ( () throws -> AppIcon ) -> Void
  ) {
    var todaysAlternate: AppIcon? {
      let currentDateComponents = Calendar.current.dateComponents(
        [ .day, .month,
          .weekOfMonth, .weekday
        ],
        from: .init()
      )
      
      if
        currentDateComponents.month == 11,
        currentDateComponents.weekOfMonth == 4,
        currentDateComponents.weekday == 5
      {return thanksgiving}
      
      switch (currentDateComponents.day!, currentDateComponents.month!) {
      case (14, 2): return valentine
      case (25, 12): return christmas
      default: return nil
      }
    }
    
    guard let icon =
      current == primary
      ? todaysAlternate
      : primary
    else {
      processGetIcon{throw AlternateError.noAlternateToday}
      return
    }
    
    UIApplication.shared.setAlternateIconName(icon.name){
      error in
      
      if let error = error {
        processGetIcon{throw error}
        return
      }
      
      processGetIcon{icon}
    }
  }
  
  var name: String? {
    switch self {
    case .primary: return nil
    case .valentine: return "Valentine"
    case .christmas: return "Christmas"
    case .thanksgiving: return "Thanksgiving"
    }
  }
}
















