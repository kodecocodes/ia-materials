/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class SearchViewController: UIViewController {
  @IBOutlet var searchBar: UISearchBar!
  @IBOutlet var tableView: UITableView!
  @IBOutlet weak var segmentedControl: UISegmentedControl!

  var landscapeVC: LandscapeViewController?
  weak var splitViewDetail: DetailViewController?
  private let search = Search()

  struct TableView {
    struct CellIdentifiers {
      static let searchResultCell = "SearchResultCell"
      static let nothingFoundCell = "NothingFoundCell"
      static let loadingCell = "LoadingCell"
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    title = NSLocalizedString("Search", comment: "split view primary button")
    tableView.contentInset = UIEdgeInsets(top: 94, left: 0, bottom: 0, right: 0)
    var cellNib = UINib(nibName: TableView.CellIdentifiers.searchResultCell, bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.searchResultCell)
    cellNib = UINib(nibName: TableView.CellIdentifiers.nothingFoundCell, bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.nothingFoundCell)
    cellNib = UINib(nibName: TableView.CellIdentifiers.loadingCell, bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.loadingCell)
    if UIDevice.current.userInterfaceIdiom != .pad {
      searchBar.becomeFirstResponder()
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if UIDevice.current.userInterfaceIdiom == .phone {
      navigationController?.navigationBar.isHidden = true
    }
  }

  override func willTransition(
    to newCollection: UITraitCollection,
    with coordinator: UIViewControllerTransitionCoordinator
  ) {
    super.willTransition(to: newCollection, with: coordinator)

    switch newCollection.verticalSizeClass {
    case .compact:
      if newCollection.horizontalSizeClass == .compact {
        showLandscape(with: coordinator)
      }
    case .regular, .unspecified:
      hideLandscape(with: coordinator)
    @unknown default:
      break
    }
  }

  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ShowDetail" {
      if case .results(let list) = search.state {
        let detailViewController = segue.destination as! DetailViewController
        let indexPath = sender as! IndexPath
        let searchResult = list[indexPath.row]
        detailViewController.searchResult = searchResult
        detailViewController.isPopUp = true
      }
    }
  }

  // MARK: - Actions
  @IBAction func segmentChanged(_ sender: UISegmentedControl) {
    performSearch()
  }

	// MARK: - Helper Methods
  func showNetworkError() {
    let alert = UIAlertController(title: NSLocalizedString("Whoops...", comment: "Network error Alert title"), message: NSLocalizedString("There was an error accessing the iTunes Store. Please try again.", comment: "Network error message"), preferredStyle: .alert)

    let action = UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button title"), style: .default, handler: nil)
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }

  func showLandscape(with coordinator: UIViewControllerTransitionCoordinator) {
    guard landscapeVC == nil else { return }
    landscapeVC = storyboard!.instantiateViewController(withIdentifier: "LandscapeViewController") as? LandscapeViewController
    if let controller = landscapeVC {
      controller.search = search
      controller.view.frame = view.bounds
      controller.view.alpha = 0

      view.addSubview(controller.view)
      addChild(controller)
      coordinator.animate(
        alongsideTransition: { _ in
          controller.view.alpha = 1
          self.searchBar.resignFirstResponder()
          if self.presentedViewController != nil {
            self.dismiss(animated: true, completion: nil)
          }
        }, completion: { _ in
          controller.didMove(toParent: self)
        }
      )
    }
  }

  func hideLandscape(with coordinator: UIViewControllerTransitionCoordinator) {
    if let controller = landscapeVC {
      controller.willMove(toParent: nil)
      coordinator.animate(
        alongsideTransition: { _ in
          controller.view.alpha = 0
          if self.presentedViewController != nil {
            self.dismiss(animated: true, completion: nil)
          }
        }, completion: { _ in
          controller.view.removeFromSuperview()
          controller.removeFromParent()
          self.landscapeVC = nil
        }
      )
    }
  }

  private func hidePrimaryPane() {
    UIView.animate(
      withDuration: 0.25,
      animations: {
        self.splitViewController!.preferredDisplayMode = .secondaryOnly
      }, completion: { _ in
        self.splitViewController!.preferredDisplayMode = .automatic
      }
    )
  }
}

// MARK: - Search Bar Delegate
extension SearchViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    performSearch()
  }

  func performSearch() {
    if let category = Search.Category(rawValue: segmentedControl.selectedSegmentIndex) {
      search.performSearch(
        for: searchBar.text!,
        category: category) { success in
        if !success {
          self.showNetworkError()
        }
        self.tableView.reloadData()
        self.landscapeVC?.searchResultsReceived()
      }

      tableView.reloadData()
      searchBar.resignFirstResponder()
    }
  }

  func position(for bar: UIBarPositioning) -> UIBarPosition {
    .topAttached
  }
}

// MARK: - Table View Delegate
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch search.state {
    case .notSearchedYet:
      return 0
    case .loading:
      return 1
    case .noResults:
      return 1
    case .results(let list):
      return list.count
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch search.state {
    case .notSearchedYet:
      fatalError("Should never get here")

    case .loading:
      let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.loadingCell, for: indexPath)
      let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
      spinner.startAnimating()
      return cell

    case .noResults:
      return tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.nothingFoundCell, for: indexPath)

    case .results(let list):
      let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.searchResultCell, for: indexPath) as! SearchResultCell
      let searchResult = list[indexPath.row]
      cell.configure(for: searchResult)
      return cell
    }
  }

  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    searchBar.resignFirstResponder()

    if view.window!.rootViewController!.traitCollection
      .horizontalSizeClass == .compact {
      tableView.deselectRow(at: indexPath, animated: true)
      performSegue(withIdentifier: "ShowDetail", sender: indexPath)
    } else {
      if case .results(let list) = search.state {
        splitViewDetail?.searchResult = list[indexPath.row]
      }
      if splitViewController!.displayMode != .oneBesideSecondary {
        hidePrimaryPane()
      }
    }
  }

  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    switch search.state {
    case .notSearchedYet, .loading, .noResults:
      return nil
    case .results:
      return indexPath
    }
  }
}
