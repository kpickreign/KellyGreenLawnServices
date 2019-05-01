//
//  AboutViewController.swift
//  Kelly Green Lawn Services App
//
//  Created by Kelly Pickreign on 4/23/19.
//  Copyright © 2019 Kelly Pickreign. All rights reserved.
//

import UIKit
import MessageUI

class AboutViewController: UIViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    // Add Website link?
    // Add contraints 
    
    @IBAction func openWebsiteButtonClicked(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://kellygreenlawnservices.com/")! as URL, options: [:], completionHandler: nil)
    }
    
    @IBAction func emailButtonPressed(_ sender: UIButton) {

        
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self

        mailComposerVC.setToRecipients(["kelly@kellygreenlawnservices.com"])
        mailComposerVC.setSubject("Interest in Kelly Green Lawn Services")

        return mailComposerVC
    }
//
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "Could not send email", message: "Your device could not send email", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "OK", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
//    func sendEmail() {
//        if MFMailComposeViewController.canSendMail() {
//            let mail = MFMailComposeViewController()
//            mail.mailComposeDelegate = self as? MFMailComposeViewControllerDelegate
//            mail.setToRecipients(["kelly@kellygreenlawnservices.com"])
//            mail.setSubject("Interest in Kelly Green Lawn Services")
//
//            present(mail, animated: true)
//        } else {
//            showSendMailErrorAlert()
//        }
//    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    


}
