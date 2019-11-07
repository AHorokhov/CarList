//
//  MapViewController.swift
//  Car list
//
//  Created by Alexey Horokhov on 07.11.2019.
//  Copyright © 2019 Alexey Horokhov. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    // MARK: Properties

    @IBOutlet private weak var mapView: MKMapView!

    private var vehicleList: [Vehicle] = []
    private var selectedVehicle: Vehicle?
    private let regionRadius: CLLocationDistance = 300

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        setupMap()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard let selectedVehicle = selectedVehicle else { return }
        showVehicle(vehicle: selectedVehicle)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        selectedVehicle = nil
    }

    // MARK: Public

    func updateWithList(list: [Vehicle]) {
        self.vehicleList = list
    }

    func updateWithSelectedVehicle(vehicle: Vehicle) {
        selectedVehicle = vehicle
    }

    // MARK: Private

    private func setupMap() {
        mapView.addAnnotations(vehicleList)
        guard let first = vehicleList.first else { return }
        showVehicle(vehicle: first)
    }

    private func showVehicle(vehicle: Vehicle) {
        let location = vehicle.coordinate
        let region = MKCoordinateRegion(center: location, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)
    }
}

// MARK: MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Vehicle else { return nil }
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
}
