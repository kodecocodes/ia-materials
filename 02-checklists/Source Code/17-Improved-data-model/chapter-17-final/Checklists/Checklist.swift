//
//  Checklist.swift
//  Checklists
//
//  Created by Fahim Farook on 04/08/2020.
//  Copyright © 2020 Razeware. All rights reserved.
//

import UIKit

class Checklist: NSObject, Codable {
  var name = ""
  var items = [ChecklistItem]()

  init(name: String) {
    self.name = name
    super.init()
  }
}
