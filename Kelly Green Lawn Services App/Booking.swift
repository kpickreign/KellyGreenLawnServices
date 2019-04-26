//
//  Booking.swift
//  Kelly Green Lawn Services App
//
//  Created by Kelly Pickreign on 4/23/19.
//  Copyright © 2019 Kelly Pickreign. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase
import MapKit

class Booking: NSObject, MKAnnotation {
    var name: String
    var address: String
    var coordinate: CLLocationCoordinate2D
    var date1: String
    var time: String
    var desiredService: String
    var createdOn: Date
    var additionalNotes: String
    var postingUserID: String
    var documentID: String
    
    var dictionary: [String: Any] {
        let timeIntervalDate = createdOn.timeIntervalSince1970
        return ["name": name, "address": address, "longitude":
            longitude, "latitude": latitude, "date1": date1, "time": time, "desiredService":
            desiredService, "createdOn": timeIntervalDate, "postingUserID": postingUserID, "additionalNotes": additionalNotes]
    }
    
    var latitude: CLLocationDegrees {
        return coordinate.latitude
    }
    
    var longitude: CLLocationDegrees {
        return coordinate.longitude
    }
    
//    var title: String? {
//        return teamName
//    }
//
//    var subtitle: String? {
//        return university
//    }
    
    
    init(name: String, address: String, coordinate: CLLocationCoordinate2D, date1: String, time: String, desiredService: String, createdOn: Date, additionalNotes:  String, postingUserID: String, documentID: String) {
        self.name = name
        self.address = address
        self.coordinate = coordinate
        self.date1 = date1
        self.time = time
        self.desiredService = desiredService
        self.createdOn = createdOn
        self.additionalNotes = additionalNotes
        self.postingUserID = postingUserID
        self.documentID = documentID
    }
    
    convenience override init() {
        self.init(name: "", address: "", coordinate: CLLocationCoordinate2D(), date1: "", time: "", desiredService: "",
            createdOn: Date(), additionalNotes: "", postingUserID: "", documentID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let name = dictionary["name"] as! String? ?? ""
        let address = dictionary["address"] as! String? ?? ""
        let latitude = dictionary["latitude"] as! CLLocationDegrees? ?? 0.0
        let longitude = dictionary["longitude"] as! CLLocationDegrees? ?? 0.0
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let date1 = dictionary["date1"] as! String? ?? ""
        let time = dictionary["time"] as! String? ?? ""
        let desiredService = dictionary["desiredService"] as! String? ?? ""
        let timeIntervalDate = dictionary["date"] as! TimeInterval? ?? TimeInterval()
        let createdOn = Date(timeIntervalSince1970: timeIntervalDate)
        let additionalNotes =  dictionary["additionalNotes"] as! String? ?? ""
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        self.init(name: name, address: address, coordinate: coordinate, date1: date1, time: time, desiredService: desiredService, createdOn: createdOn, additionalNotes: additionalNotes, postingUserID: postingUserID, documentID: "")
        
    }
    

    // NOTE: If you keep the same programming conventions (e.g. a calculated property .dictionary that converts class properties to String: Any pairs, the name of the document stored in the class as .documentID) then the only thing you'll need to change is the document path (i.e. the lines containing "spots" below.
    func saveData(completion: @escaping (Bool) -> ())  {
        let db = Firestore.firestore()
        // Grab the user ID
        guard let postingUserID = (Auth.auth().currentUser?.uid) else {
            print("*** ERROR: Could not save data because we don't have a valid postingUserID")
            return completion(false)
        }
        self.postingUserID = postingUserID
        // Create the dictionary representing data we want to save
        let dataToSave: [String: Any] = self.dictionary
        // if we HAVE saved a record, we'll have an ID
        if self.documentID != "" {
            let ref = db.collection("bookings").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("ERROR: updating document \(error.localizedDescription)")
                    completion(false)
                } else { // It worked!
                    completion(true)
                }
            }
        } else { // Otherwise create a new document via .addDocument
            var ref: DocumentReference? = nil // Firestore will creat a new ID for us
            ref = db.collection("bookings").addDocument(data: dataToSave) { (error) in
                if let error = error {
                    print("ERROR: adding document \(error.localizedDescription)")
                    completion(false)
                } else { // It worked! Save the documentID in Spot’s documentID property
                    self.documentID = ref!.documentID
                    completion(true)
                }
            }
        }
    }
    
    
    func deleteData(completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        db.collection("bookings").document(documentID).delete() { error in
            if let error = error {
                print("😡 ERROR: deleting review documentID \(self.documentID) \(error.localizedDescription)")
                completed(false)
            } else {
                    completed(true)
            }
        }
    }
    
    
}


