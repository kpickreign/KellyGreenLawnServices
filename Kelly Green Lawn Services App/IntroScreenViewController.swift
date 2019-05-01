//
//  IntroScreenViewController.swift
//  Kelly Green Lawn Services App
//
//  Created by Kelly Pickreign on 4/23/19.
//  Copyright © 2019 Kelly Pickreign. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import GoogleSignIn 

class IntroScreenViewController: UIViewController {

    @IBOutlet weak var lawnMowerImage: UIImageView!
    @IBOutlet weak var kellyGreenLabel: UILabel!
    @IBOutlet weak var bookNowButton: UIButton!
    @IBOutlet weak var exploreServicesButton: UIButton!
    
    var authUI: FUIAuth!
    var imageY: CGFloat!
    var kellyGreenY: CGFloat!
    var bookNowY: CGFloat!
    var exploreServicesY: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageY = lawnMowerImage.frame.origin.y
        kellyGreenY = kellyGreenLabel.frame.origin.y
        bookNowY = bookNowButton.frame.origin.y
        exploreServicesY = exploreServicesButton.frame.origin.y
        
        authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        lawnMowerImage.frame.origin.y =  view.frame.height
        UIView.animate(withDuration: 1.0, delay: 1.0, animations: {self.lawnMowerImage.frame.origin.y = self.imageY})
        kellyGreenLabel.frame.origin.y =  view.frame.height
        UIView.animate(withDuration: 1.0, delay: 1.0, animations: {self.kellyGreenLabel.frame.origin.y = self.kellyGreenY})
        bookNowButton.frame.origin.y =  view.frame.height
        UIView.animate(withDuration: 1.0, delay: 1.0, animations: {self.bookNowButton.frame.origin.y = self.bookNowY})
        exploreServicesButton.frame.origin.y =  view.frame.height
        UIView.animate(withDuration: 1.0, delay: 1.0, animations: {self.exploreServicesButton.frame.origin.y = self.exploreServicesY})
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        signIn()
    }
    
    func signIn() {
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth(),
            ]
        if authUI.auth?.currentUser == nil {
            self.authUI?.providers = providers
            present(authUI.authViewController(), animated: true, completion: nil)
        } else {
//            tableView.isHidden = false
        }
    }
    
    @IBAction func signOutPressed(_ sender: UIBarButtonItem) {
        do {
            try authUI.signOut()
            print("Successfuly signed out")
//            tableView.isHidden = true
            signIn()
        } catch {
//            tableView.isHidden = true
            print("ERROR: Couldn't sign out")
        }
        
    }
    
    @IBAction func bookNowButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func exploreServicesButtonPressed(_ sender: UIButton) {
    }
}

extension IntroScreenViewController: FUIAuthDelegate {
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        return false
    }
    
//    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
//        if let user = user {
//            // Assumes data will be isplayed in a tableView that was hidden until login was verified so unauthorized users can't see data.
//            tableView.isHidden = false
//            print("^^^ We signed in with the user \(user.email ?? "unknown e-mail")")
//        }
//    }
    
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        
        // Create an instance of the FirebaseAuth login view controller
        let loginViewController = FUIAuthPickerViewController(authUI: authUI)
        
        // Set background color to white
        loginViewController.view.backgroundColor = UIColor.white
        
                // Create a frame for a UIImageView to hold our logo
                let marginInsets: CGFloat = 16 // logo will be 16 points from L and R margins
                let imageHeight: CGFloat = 225 // the height of our logo
                let imageY = self.view.center.y - imageHeight // places bottom of UIImageView in the center of the login screen
                let logoFrame = CGRect(x: self.view.frame.origin.x + marginInsets, y: imageY, width: self.view.frame.width - (marginInsets*2), height: imageHeight)
        
                // Create the UIImageView using the frame created above & add the "logo" image
                let logoImageView = UIImageView(frame: logoFrame)
                logoImageView.image = UIImage(named: "logo")
                logoImageView.contentMode = .scaleAspectFit // Set imageView to Aspect Fit
                loginViewController.view.addSubview(logoImageView) // Add ImageView to the login controller's main view
        return loginViewController
    }
}

