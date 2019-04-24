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

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if booking == nil {
            booking = Booking()
        }
        
        
        let region = MKCoordinateRegion(center: booking.coordinate, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        mapView.setRegion(region, animated: true)
        
        updateUserInterfaace()


    }
    
    func updateUserInterfaace() {
        nameField.text = booking.name
        addressField.text = booking.address
        dateField.text = booking.date1
        timeField.text = booking.time
        desiredServiceField.text = booking.desiredService
        additionalNotesTextView.text = booking.additionalNotes
       // updateMap()
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
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
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
            } else {
                print("*** ERROR: Couldn't leave this view controller because data wasn't saved.")
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
}

  


