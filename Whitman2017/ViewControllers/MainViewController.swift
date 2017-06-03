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
    
    @IBOutlet weak var navigationTitleView: UIView!
    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet weak var chatViewHeightConstraint: NSLayoutConstraint!
    
    var layer: CAGradientLayer!
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setGradientBar()
        if let chatVC = childViewControllers.first as? ChatViewController {
            chatVC.delegate = self
        }
        mapView.userTrackingMode = .followWithHeading
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
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
        return nil
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
}

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        mapView.setCenter(center, zoomLevel: 14, animated: true)
        locationManager.stopUpdatingLocation()
    }
}

