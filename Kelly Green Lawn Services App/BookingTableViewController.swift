//
//  BookingTableViewController.swift
//  Kelly Green Lawn Services App
//
//  Created by Kelly Pickreign on 4/23/19.
//  Copyright © 2019 Kelly Pickreign. All rights reserved.
//

import UIKit
import GooglePlaces
import MapKit
import Contacts

class BookingTableViewController: UITableViewController {
    
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var desiredServiceField: UITextField!
    @IBOutlet weak var additionalNotesTextView: UITextView!
    
    var booking: Booking!
    var regionDistance: CLLocationDistance = 50000 // half mile, meters
    var editingABooking = true
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if booking == nil {
            editingABooking = false
            booking = Booking()
        }
        
        
        let region = MKCoordinateRegion(center: booking.coordinate, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        mapView.setRegion(region, animated: true)
        
        updateUserInterfaace()


    }
    

    
    @IBAction func addressTextFieldClicked(_ sender: UITextField) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    
    
    func updateUserInterfaace() {
        nameField.text = booking.name
        addressField.text = booking.address
        dateField.text = booking.date1
        timeField.text = booking.time
        desiredServiceField.text = booking.desiredService
        additionalNotesTextView.text = booking.additionalNotes
        updateMap()
    }
    
    func updateDataFromInterface() {
        // If you're reusing this code, the code inside this function should be modified to fit the needs of the specific Interface and Object being used.
        booking.name = nameField.text!
        booking.address = addressField.text!
        booking.date1 = dateField.text!
        booking.time = timeField.text!
        booking.desiredService = desiredServiceField.text!
        booking.additionalNotes = additionalNotesTextView.text
        
    }
    
    func updateMap() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(booking)
        mapView.setCenter(booking.coordinate, animated: true)
    }
    
    func leaveViewController() {
        
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode && !editingABooking {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        // When reusing this code, the only changes required may be to spot.saveData (you'll likley have a different object, and it is possible that you might pass in parameters if you're saving to a longer document reference path
        updateDataFromInterface()
        booking.saveData { success in
            if success {
                self.leaveViewController()
                print("success")
            } else {
                print("*** ERROR: Couldn't leave this view controller because data wasn't saved.")
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
}

extension BookingTableViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        updateDataFromInterface() // Get what the user has entered before calling updateUserInterface, below
        booking.address = place.name ?? "<place unnamed>"
        booking.coordinate = place.coordinate
        dismiss(animated: true, completion: nil)
        updateUserInterfaace()
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

  


