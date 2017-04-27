//
//  SearchViewController.swift
//  FSAPI
//
//  Created by ardMac on 25/04/2017.
//  Copyright © 2017 ardMac. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }

    @IBAction func searchButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard (name: "Main", bundle: Bundle.main)
        if let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
            vc.query = textField.text!
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}
