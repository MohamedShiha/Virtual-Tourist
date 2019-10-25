//
//  TravelLocationsVC.swift
//  Virtual Tourist
//
//  Created by Mohamed Shiha on 8/8/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class TravelMapController: UIViewController {

    // MARK: Properties
    let dataController = DataController.shared
    var pins = [Pin]()
    
    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveConfigInfo()
        navigationController?.navigationBar.isHidden = true
        setupMap()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
   
    // MARK : Load Pins from Database
    private func fetchPins(){
        
        let pins = Entity<Pin>.fetchPins()

        if let pins = pins {
            self.pins = pins
        }
    }
    
    private func setupMap() {
        
        fetchPins()
        
        if pins.count > 0 {
            for pin in pins {
                let annotation = MKPointAnnotation()
                annotation.coordinate.latitude = pin.latitude
                annotation.coordinate.longitude = pin.longitude
                mapView.addAnnotation(annotation)
            }
        }
    }
    
    // MARK: User Config
    
    // Save Configuration Info
    func saveConfigInfo(for mapView : MKMapView) {

        let mapRegion = getMapState(from: mapView)
        let userDefaults = UserDefaults.standard
        
        userDefaults.setValue(mapRegion.center.latitude, forKey: "latitude")
        userDefaults.setValue(mapRegion.center.longitude, forKey: "longitude")
        userDefaults.setValue(mapRegion.span.latitudeDelta, forKey: "latitudeDelta")
        userDefaults.setValue(mapRegion.span.longitudeDelta, forKey: "longitudeDelta")
        userDefaults.synchronize()
    }
    
    // Retrieve Confguration Info
    func retrieveConfigInfo() {
        
        let userDefaults = UserDefaults.standard
        
        let latitude = userDefaults.value(forKey: "latitude") as! CLLocationDegrees
        let longitude = userDefaults.value(forKey: "longitude") as! CLLocationDegrees
        let latitudeDelta = userDefaults.value(forKey: "latitudeDelta") as! CLLocationDegrees
        let longitudeDelta = userDefaults.value(forKey: "longitudeDelta") as! CLLocationDegrees
        
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        
        let userMapRegion = MKCoordinateRegion(center: center, span: span)
        
        mapView.setRegion(userMapRegion, animated: true)
    }
}


// MARK : MapView
extension TravelMapController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        let reuseID = "travelPin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView!.pinTintColor = .red
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView  
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let photoAlbumVC = storyboard?.instantiateViewController(withIdentifier: "photoAlbum") as! PhotoAlbumController
        photoAlbumVC.pinCoordinate = view.annotation?.coordinate
        
        let backBtn = UIBarButtonItem()
        backBtn.title = "OK"
        backBtn.tintColor = #colorLiteral(red: 0.08235294118, green: 0.6392156863, blue: 0.8666666667, alpha: 1)
        navigationItem.backBarButtonItem = backBtn
        
        navigationController?.pushViewController(photoAlbumVC, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        saveConfigInfo(for: mapView)
        print("Map preferences have been changed")
    }
    
    // MapView longPress gesture Handler
    @IBAction func dropPinHandler(gestureRecogniser: UILongPressGestureRecognizer){
        if gestureRecogniser.state == .began {
            let tappedPoint = gestureRecogniser.location(in: mapView)
            let coordinate = mapView.convert(tappedPoint, toCoordinateFrom: mapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            
            createPinRecord(coordinate: annotation.coordinate)
        }
    }
    
    private func createPinRecord(coordinate : CLLocationCoordinate2D) {
        let newPin = Pin(context: dataController.viewContext)
        newPin.latitude = round(coordinate.latitude * 100000) / 100000
        newPin.longitude = round(coordinate.longitude * 100000) / 100000
        try? dataController.viewContext.save()
    }
    
    // Reserving MapView State
    func getMapState(from mapView: MKMapView) -> MKCoordinateRegion {
        let span = mapView.region.span
        let center = mapView.centerCoordinate
        return MKCoordinateRegion(center: center, span: span)
    }
}
