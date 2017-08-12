//
//  ViewController.swift
//  PokeFinder
//
//  Created by AADITYA NARVEKAR on 7/27/17.
//  Copyright © 2017 Aaditya Narvekar. All rights reserved.
//

import UIKit
import Firebase

class MainVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, PokemonSelectedDelegate {

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    private var hasCenteredLocationOnce = false
    var geoFire: GeoFire?
    
    override func viewDidLoad() {
        super.viewDidLoad()                
        
        mapView.delegate = self
        locationManager.delegate = self
        mapView.userTrackingMode = MKUserTrackingMode.follow
        
        let geofireRef = Database.database().reference()
        geoFire = GeoFire(firebaseRef: geofireRef)
        print("GeoFire Initialized")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationAuthStatus()
    }
    
    func locationAuthStatus() {
        let authStatus: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        if authStatus == .notDetermined {
            // Request access
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            mapView.showsUserLocation = true
            if let location = mapView.userLocation.location {
                centerMapAtLocation(location: location)
            }
        } else if status == .denied || status == .restricted {
            print(status)
            let alert = UIAlertController(title: "Location Denied", message: "Location Services needed for the application. You can edit access through settings", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            let settingsAction = UIAlertAction(title: "Go to Settings", style: .default, handler: { (action) in
                let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)!
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            })
            
            alert.addAction(cancelAction)
            alert.addAction(settingsAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView: MKAnnotationView?
        if annotation.isKind(of: MKUserLocation.self) {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Ash")
            annotationView?.image = UIImage(named: "ash")
        } else if annotation.isKind(of: PokemonAnnotation.self) {
            if let deqAnno = mapView.dequeueReusableAnnotationView(withIdentifier: "Pokemon") {
                annotationView = deqAnno
                annotationView?.annotation = annotation
            } else {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Pokemon")
                annotationView?.canShowCallout = true
                annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
            annotationView?.image = UIImage(named: "\((annotation as! PokemonAnnotation).pokeId)")
            let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            btn.setImage(UIImage(named: "location-map-flat"), for: .normal)
            annotationView?.rightCalloutAccessoryView = btn
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("Callout accessory tapped")
        if let coordinate = view.annotation?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000)
            let options = [
                MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: region.center),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: region.span)
            ] as [String : Any]
            let placemark =  MKPlacemark(coordinate: coordinate)
            let mapItem = MKMapItem(placemark: placemark)
            if let name = view.annotation?.title {
                mapItem.name = name
            } else {
                mapItem.name = "Pokemon Sighted"
            }
            mapItem.openInMaps(launchOptions: options)
        }
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        print("Update location called")
        if let location = userLocation.location {
            if !hasCenteredLocationOnce {
                centerMapAtLocation(location: location)
                hasCenteredLocationOnce = true
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let centerLocation = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        showSightingsOnMap(location: centerLocation)
    }
    
    private func centerMapAtLocation(location: CLLocation) {
        let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 7500, 7500)
        mapView.setRegion(region, animated: true)
    }
    
    func createSighting(forPokemon pokemon: Pokemon, atLocation location: CLLocation) {
        if let gf = geoFire {
            gf.setLocation(location, forKey: "\(pokemon.pokemonId)", withCompletionBlock: { (error) in
                if error != nil {
                    print("Error creating sighting: \(error.debugDescription)")
                }
            })
        }
    }
    
    func showSightingsOnMap(location: CLLocation) {
        if let gf = geoFire {
            let circleQuery = gf.query(at: location, withRadius: 2.5)
            _ = circleQuery?.observe(.keyEntered, with: { (key: String!, location: CLLocation!) in
                if let key = key, let location = location {
                    print("Obtained location for \(key) at \(location.description)")
                    let pokemonAnnotation = PokemonAnnotation(coordinate: location.coordinate, pokeId: Int(key)!)
                    self.mapView.addAnnotation(pokemonAnnotation)
                }
            })
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PokemonVC {
            destination.delegate = self
        }
    }
    
    func handlePokemonSelected(pokemon: Pokemon) {
        let center = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        createSighting(forPokemon: pokemon, atLocation: center)
    }
    
    
}

