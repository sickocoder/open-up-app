//
//  Date+Ext.swift
//  OpenUp
//
//  Created by José Tony on 08/08/22.
//

import Foundation

extension Date {
  var millisecondsSince1970: Int64 {
    Int64((self.timeIntervalSince1970 * 1000.0).rounded())
  }
}
