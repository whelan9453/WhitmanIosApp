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
    
    var mapView: MGLMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layoutIfNeeded()
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
