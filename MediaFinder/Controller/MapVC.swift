//
//  MapVC.swift
//  MediaFinder
//
//  Created by Karim Mohamed on 20/12/2022.
//

import MapKit

protocol SendAddress: AnyObject {
    func sendAddress(address: String)
}

class MapVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var userAddressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Variables & properties
    private let locationManager = CLLocationManager()
    weak var delegate: SendAddress?
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        checkLocationServices()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    // MARK: - Actions
    @IBAction func confirmBtnTapped(_ sender: UIButton) {
        let address = userAddressLabel.text ?? ""
        delegate?.sendAddress(address: address)
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - MapView Delegate
extension MapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let lat = mapView.centerCoordinate.latitude
        let long = mapView.centerCoordinate.longitude
        let location = CLLocation(latitude: lat, longitude: long)
        setAddressFrom(location: location)
    }
}

// MARK: - private Methods.
extension MapVC {
    private func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled() {
            checkLocationAuthentication()
        }else {
            showAlert(title: "sorry", message: "Can't Get location open GPS")
        }
    }
    private func checkLocationAuthentication() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways,.authorizedWhenInUse:
//           centerMapOnSpecificLocation()
            centerMapOnCurrentLocation()
        case .restricted, .denied:
            showAlert(title: "sorry", message: "Can't Get location \n please insert location")
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            showAlert(title: "sorry", message: "Can't Get location \n try again later")
        }
    }
    /// TESTING
    private func centerMapOnSpecificLocation(){
        let location = CLLocation(latitude: 29.982611, longitude: 31.3162252)
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(region, animated: true)
        setAddressFrom(location: location)
    }
    private func centerMapOnCurrentLocation(){
        if let location = locationManager.location{
            let region = MKCoordinateRegion(center: location.coordinate ,latitudinalMeters: 10000, longitudinalMeters: 10000)
            mapView.setRegion(region, animated: true)
            setAddressFrom(location: location)
        }
    }
    private func setAddressFrom(location: CLLocation){
        let geoCoder = CLGeocoder() // convert lat and long
        geoCoder.reverseGeocodeLocation(location) { placeMarks, error in
            if let error = error{
                print(error)
            }else if let firstPlaceMarks = placeMarks?.first{
                self.userAddressLabel.text = firstPlaceMarks.compactAddress
            }
        }
    }
}
