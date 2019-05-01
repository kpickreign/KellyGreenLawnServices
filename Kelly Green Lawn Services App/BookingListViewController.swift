//
//  BookingListViewController.swift
//  Kelly Green Lawn Services App
//
//  Created by Kelly Pickreign on 4/23/19.
//  Copyright © 2019 Kelly Pickreign. All rights reserved.
//


import UIKit
import Firebase
import FirebaseUI


class BookingListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    
    
//    var authUI: FUIAuth!
    var bookings: Bookings!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bookings = Bookings()
        
//        authUI = FUIAuth.defaultAuthUI()
//        authUI?.delegate = self
//
        // if you have a table view, you'll want this code, too. The .isHidden will hide the table view data so that it cannot be seen by someone who isn't logged in.
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.isHidden = true


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        bookings.loadData {
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowBooking" {
            let destination = segue.destination as! BookingTableViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.booking = bookings.bookingArray[selectedIndexPath.row]
        } else {
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
    }
    
    @IBAction func editBarButtonPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing == true {
            tableView.setEditing(false, animated: true)
            editBarButton.title = "Edit"
            addBarButton.isEnabled = true
            cancelBarButton.isEnabled = true
        } else {
            tableView.setEditing(true, animated: true)
            editBarButton.title = "Done"
            addBarButton.isEnabled = false
            cancelBarButton.isEnabled = false
            
        }
    }
    
    @IBAction func cancelBarButtonPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    

}



extension BookingListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookings.bookingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = bookings.bookingArray[indexPath.row].name
        cell.detailTextLabel?.text = bookings.bookingArray[indexPath.row].date1
        return cell
    }
    
//    //MARK:- TableView Editing Function
//
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            bookings.bookingArray[indexPath.row].deleteData() { success in
                if success {
                    print("Success!!")
                } else {
                    print("😡 Delete unsuccessful.")
                }
            }
        }
    }

//    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        let itemToMove = bookings.bookingArray[sourceIndexPath.row]
//        bookings.bookingArray.remove(at: sourceIndexPath.row)
//        bookings.bookingArray.insert(itemToMove, at: destinationIndexPath.row)
////        saveLocations()
//    }
//
//    //MARK:- TableView Methods to Freeze The First Cell
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        //        if indexPath.row != 0 {
//        //            return true
//        //        } else {
//        //            return false
//        //        }
//        return (indexPath.row != 0 ? true:false)
//    }
//
//    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        //        if indexPath.row != 0 {
//        //            return true
//        //        } else {
//        //            return false
//        //        }
//        return (indexPath.row != 0 ? true:false)
//
//    }
//    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
//        if proposedDestinationIndexPath.row == 0 {
//            return sourceIndexPath
//        } else {
//            return proposedDestinationIndexPath
//        }
//
//    }
//
////    func updateTable(place: GMSPlace) {
////        let newIndexPath = IndexPath(row: locationsArray.count, section: 0)
////
////        let latitude = place.coordinate.latitude
////        let longitude = place.coordinate.longitude
////        let newCoordinates = "\(latitude),\(longitude)"
////        let newWeatherLocation = WeatherLocation(name: place.name!, coordinates: newCoordinates)
////
////        locationsArray.append(newWeatherLocation)
////        tableView.insertRows(at: [newIndexPath], with: .automatic)
////        saveLocations()
////    }
}



