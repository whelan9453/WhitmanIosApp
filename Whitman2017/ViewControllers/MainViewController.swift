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
    func getUserCoordinate() -> CLLocationCoordinate2D?
    func setResetBarItem(with state: Bool)
}

protocol MainViewControllerDelegate: class {
    func resetRegion()
    func hideMessageView()
}

class MainViewController: UIViewController {
    
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var chatViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var userPositionButton: UIButton!
    @IBOutlet weak var orientationButton: UIButton!
    @IBOutlet weak var resetBarItem: UIBarButtonItem!
    
    let locationManager = CLLocationManager()
    
    var mapView: MGLMapView!
    weak var delegate: MainViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layoutIfNeeded()
        
        locationManager.delegate = self
        
        navigationController?.setGradientBar()
        if let chatVC = childViewControllers.first as? ChatViewController {
            chatVC.delegate = self
            delegate = chatVC
        }
        UIApplication.shared.statusBarStyle = .lightContent
        
        mapView = MGLMapView(frame: mapContainerView.bounds)
        mapView.styleURL = URL(string: "mapbox://styles/eward-esi/cj2wbd9g200052sp0hk2miufu")
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.zoomLevel = 18
        mapView.compassView.isHidden = true
        mapContainerView.addSubview(mapView)
        setupTaskPoint()
    }
    
    func setupTaskPoint() {
        let pointAnnotations = TaskRegion.all.map { $0.point }
        mapView.addAnnotations(pointAnnotations)
        // geofencing setting
        pointAnnotations.forEach { (annotation) in
            let region = CLCircularRegion(center: annotation.coordinate, radius: 50.0, identifier: annotation.title!)
            locationManager.startMonitoring(for: region)
        }
        
    }
    
    func tapAction() {
        view.endEditing(true)
        reSizeHeight(Constants.chatVCMinHeight)
        delegate?.hideMessageView()
    }
    
    @IBAction func userPositionAction(_ sender: UIButton) {
        guard let location = mapView.userLocation else {
            return
        }
        mapView.setCenter(location.coordinate, animated: true)
        mapView.userTrackingMode = .followWithHeading
    }
    
    @IBAction func orientationAction(_ sender: UIButton) {
        if mapView.userTrackingMode != .followWithHeading {
            mapView.userTrackingMode = .followWithHeading
        } else {
            mapView.resetNorth()
        }
    }
    
    @IBAction func resetTaskAction(_ sender: UIBarButtonItem) {
        delegate?.resetRegion()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
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
    
    func getUserCoordinate() -> CLLocationCoordinate2D? {
        guard let coordinate = mapView.userLocation?.coordinate else {
            return nil
        }
        return coordinate
    }
    
    func setResetBarItem(with state: Bool) {
        navigationItem.rightBarButtonItem = state ? resetBarItem : nil
    }
}

extension MainViewController: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
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
        mapView.setCenter(mapView.userLocation!.coordinate, animated: false)
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .followWithHeading
    }
    
}
