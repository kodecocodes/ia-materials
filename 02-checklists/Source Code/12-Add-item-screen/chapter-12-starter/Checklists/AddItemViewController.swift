//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Fahim Farook on 01/08/2020.
//  Copyright © 2020 Razeware. All rights reserved.
//

import UIKit

class AddItemViewController: UITableViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.largeTitleDisplayMode = .never
  }

  // MARK: - Actions
  @IBAction func cancel() {
    navigationController?.popViewController(animated: true)
  }

  @IBAction func done() {
    navigationController?.popViewController(animated: true)
  }
}
