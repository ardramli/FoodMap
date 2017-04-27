//
//  DetailViewController.swift
//  FSAPI
//
//  Created by ardMac on 25/04/2017.
//  Copyright © 2017 ardMac. All rights reserved.
//

import UIKit
import SafariServices

class DetailViewController: UIViewController {
    var selectedVenue : Venue!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!{
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(urlTapped))
            urlLabel.addGestureRecognizer(tap)
            urlLabel.isUserInteractionEnabled = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if selectedVenue == nil {
            return
        }
        
        nameLabel.text = "Name: " + selectedVenue.name
        phoneLabel.text = "Phone: " + selectedVenue.phone
        addressLabel.text = "Address: " + selectedVenue.address
        categoryLabel.text = "Category: " + selectedVenue.category
        urlLabel.text = selectedVenue.url

        // Do any additional setup after loading the view.
    }
    
    func urlTapped() {
        if self.selectedVenue.url == nil {return}
        else {
            UIApplication.shared.openURL(URL(string: "\(selectedVenue.url)")!)
        }
        
    }
    

}
