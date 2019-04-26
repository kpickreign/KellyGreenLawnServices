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
}



