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
import MapKit
import CoreData

class MapViewController: UIViewController {
  @IBOutlet weak var mapView: MKMapView!

  var locations = [Location]()

  var managedObjectContext: NSManagedObjectContext! {
    didSet {
      NotificationCenter.default.addObserver(forName: Notification.Name.NSManagedObjectContextObjectsDidChange, object: managedObjectContext, queue: OperationQueue.main) { _ in
        if self.isViewLoaded {
          self.updateLocations()
        }
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    updateLocations()
    if !locations.isEmpty {
      showLocations()
    }
  }

  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "EditLocation" {
      let controller = segue.destination as! LocationDetailsViewController
      controller.managedObjectContext = managedObjectContext

      let button = sender as! UIButton
      let location = locations[button.tag]
      controller.locationToEdit = location
    }
  }

  // MARK: - Actions
  @IBAction func showUser() {
    let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
    mapView.setRegion(mapView.regionThatFits(region), animated: true)
  }

  @IBAction func showLocations() {
    let theRegion = region(for: locations)
    mapView.setRegion(theRegion, animated: true)
  }

  // MARK: - Helper methods
  func updateLocations() {
    mapView.removeAnnotations(locations)

    let entity = Location.entity()

    let fetchRequest = NSFetchRequest<Location>()
    fetchRequest.entity = entity

    locations = try! managedObjectContext.fetch(fetchRequest)
    mapView.addAnnotations(locations)
  }

  func region(for annotations: [MKAnnotation]) -> MKCoordinateRegion {
    let region: MKCoordinateRegion

    switch annotations.count {
    case 0:
      region = MKCoordinateRegion(center: mapView.userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)

    case 1:
      let annotation = annotations[annotations.count - 1]
      region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)

    default:
      var topLeft = CLLocationCoordinate2D(latitude: -90, longitude: 180)
      var bottomRight = CLLocationCoordinate2D(latitude: 90, longitude: -180)

      for annotation in annotations {
        topLeft.latitude = max(topLeft.latitude, annotation.coordinate.latitude)
        topLeft.longitude = min(topLeft.longitude, annotation.coordinate.longitude)
        bottomRight.latitude = min(bottomRight.latitude, annotation.coordinate.latitude)
        bottomRight.longitude = max(bottomRight.longitude, annotation.coordinate.longitude)
      }

      let center = CLLocationCoordinate2D(
        latitude: topLeft.latitude - (topLeft.latitude - bottomRight.latitude) / 2,
        longitude: topLeft.longitude - (topLeft.longitude - bottomRight.longitude) / 2)

      let extraSpace = 1.1
      let span = MKCoordinateSpan(latitudeDelta: abs(topLeft.latitude - bottomRight.latitude) * extraSpace, longitudeDelta: abs(topLeft.longitude - bottomRight.longitude) * extraSpace)

      region = MKCoordinateRegion(center: center, span: span)
    }

    return mapView.regionThatFits(region)
  }

  @objc func showLocationDetails(_ sender: UIButton) {
    performSegue(withIdentifier: "EditLocation", sender: sender)
  }
}

extension MapViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard annotation is Location else {
      return nil
    }
    let identifier = "Location"
    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
    if annotationView == nil {
      let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
      pinView.isEnabled = true
      pinView.canShowCallout = true
      pinView.animatesDrop = false
      pinView.pinTintColor = UIColor(red: 0.32, green: 0.82, blue: 0.4, alpha: 1)

      let rightButton = UIButton(type: .detailDisclosure)
      rightButton.addTarget(self, action: #selector(showLocationDetails(_:)), for: .touchUpInside)
      pinView.rightCalloutAccessoryView = rightButton

      annotationView = pinView
    }

    if let annotationView = annotationView {
      annotationView.annotation = annotation

      let button = annotationView.rightCalloutAccessoryView as! UIButton
      if let index = locations.firstIndex(of: annotation as! Location) {
        button.tag = index
      }
    }

    return annotationView
  }
}
