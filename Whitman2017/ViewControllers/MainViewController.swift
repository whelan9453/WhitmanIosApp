//
//  MainViewController.swift
//  Whitman2017
//
//  Created by Toby Hsu on 2017/4/9.
//  Copyright © 2017年 Orav. All rights reserved.
//

import UIKit
import Mapbox

protocol ChatViewControllerDelegate: class {
    func reSizeHeight(_ height: CGFloat)
}

class MainViewController: UIViewController {
    
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var chatViewHeightConstraint: NSLayoutConstraint!
    
    let locationManager = CLLocationManager()
    
    var mapView: MGLMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layoutIfNeeded()
        
        locationManager.delegate = self
        
        navigationController?.setGradientBar()
        if let chatVC = childViewControllers.first as? ChatViewController {
            chatVC.delegate = self
        }
        UIApplication.shared.statusBarStyle = .lightContent
        
        mapView = MGLMapView(frame: mapContainerView.bounds)
        mapView.styleURL = URL(string: "mapbox://styles/eward-esi/cj2wbd9g200052sp0hk2miufu")
        mapView.delegate = self
        mapView.showsUserLocation = false
        mapView.zoomLevel = 18
        mapView.compassView.isHidden = true
        mapContainerView.addSubview(mapView)
        setupTaskPoint()
    }
    
    func setupTaskPoint() {
        let pointAnnotations = TaskRegion.all.map { $0.point }
        mapView.addAnnotations(pointAnnotations)
        
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    //Core Location requires each geofence to be represented as a CLCircularRegion instance before it can be registered for monitoring.
    func region(withGeotification geotification: Geotification) -> CLCircularRegion {
        let region = CLCircularRegion(center: geotification.coordinate, radius: geotification.radius, identifier: geotification.identifier)
        region.notifyOnEntry = (geotification.eventType == .onEntry)
        region.notifyOnExit = (geotification.eventType == .onExit)
        return region
    }
    
    func startMonitoring(geotification: Geotification) {
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            showAlert(withTitle:"Error", message: "Geofencing is not supported on this device!")
            return
        }
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            showAlert(withTitle:"Warning", message: "Your geotification is saved but will only be activated once you grant Geotify permission to access the device location.")
        }
        let region = self.region(withGeotification: geotification)
        locationManager.startMonitoring(for: region)
    }
    
    func stopMonitoring(geotification: Geotification) {
        for region in locationManager.monitoredRegions {
            guard let circularRegion = region as? CLCircularRegion, circularRegion.identifier == geotification.identifier else { continue }
            locationManager.stopMonitoring(for: circularRegion)
        }
    }

}

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Monitoring failed for region with identifier: \(region!.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager failed with the following error: \(error)")
    }
}

extension MainViewController: ChatViewControllerDelegate {
    func reSizeHeight(_ height: CGFloat) {
        chatViewHeightConstraint.constant = height
        UIView.animate(withDuration: 0.35) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
}

extension MainViewController: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        print("MGLAnnotationImage")
        return nil
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
//        mapView.showsUserLocation = true
//        mapView.userTrackingMode = .followWithHeading
        return true
    }
    
    func mapView(_ mapView: MGLMapView, calloutViewFor annotation: MGLAnnotation) -> MGLCalloutView? {
        if annotation.responds(to: #selector(getter: UIPreviewActionItem.title)) {
            return PromptView(representedObject: annotation)
        }
        
        return nil
    }
    
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {        
        mapView.deselectAnnotation(annotation, animated: true)
    }
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        guard annotation is MGLPointAnnotation, let title = annotation.title,
            let region = TaskRegion.getRegion(with: title!) else {
            return nil
        }
        let reuseIdentifier = title!
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        if annotationView == nil {
            annotationView = MGLUserLocationAnnotationView(reuseIdentifier: reuseIdentifier)
            annotationView?.frame.size = CGSize(width: 33, height: 49)
            annotationView?.addSubview(UIImageView(image: region.image))
        }
        return annotationView
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        mapView.setCenter(TaskRegion.HQ.point.coordinate, animated: true)
//        mapView.setCenter(mapView.userLocation!.coordinate, animated: false)
//        mapView.userTrackingMode = .followWithHeading
    }
    
    
    
    func mapView(_ mapView: MGLMapView, didChange mode: MGLUserTrackingMode, animated: Bool) {
        
    }
    
}
