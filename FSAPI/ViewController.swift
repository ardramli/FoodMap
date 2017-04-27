//
//  ViewController.swift
//  FSAPI
//
//  Created by ardMac on 25/04/2017.
//  Copyright © 2017 ardMac. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!{
        didSet{
            mapView.delegate = self
        }
    }
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var viewTable: UIView!
    @IBOutlet weak var viewMap: UIView!
    @IBOutlet weak var venuesTableView: UITableView! {
        didSet {
            venuesTableView.delegate = self
            venuesTableView.dataSource = self
        }
    }
    
    @IBAction func indexChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            viewMap.isHidden = true
            viewTable.isHidden = false
        case 1:
            viewMap.isHidden = false
            viewTable.isHidden = true
            setupMapView()
        default:
            break;
        }
    }
    
    
   
    
    
    var venues = [Venue]()
    var query = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let urlString = "https://api.foursquare.com/v2/venues/search?client_id=D5VODS1CNDWXF13IT3NEJ0TKPMHEV2ZJBDF5YSQRL4PCMJQQ&client_secret=XWLJUCNZWU2IMIESMJARWKTKNKBKLSDPYM0FKDL3IOP42ZDK&v=20130815&ll=3.134973,101.630629&query=\(query)"
        guard let url = URL(string: urlString)
            else {return}
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { (data, response, error) in
            
            if let err = error {
                print("Error \(err.localizedDescription)" )
                return
            }
            guard let data = data
                else {
                    print ("Data error")
                    return
            }
            print(data)
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
                
                if let dictData = jsonData as? [String : Any] {
                    if let response = dictData["response"] as? [String : Any]{
                        if let venue = response["venues"] as? [[String : Any]] {
                            self.populateVenue(venue)
                        }
                    }
                }
            }catch {
                print ("Error when converting to JSON")
            }
        }
        task.resume()
    }
    
    func populateVenue(_ array : [[String: Any]]){
        for venue in array {
            venues.append(Venue(dict: venue))
        }
        DispatchQueue.main.async {
            self.venuesTableView.reloadData()
        }
    }
    
    func setupMapView() {
        for each in venues {
            let nextAnnotation = MKPointAnnotation()
            nextAnnotation.title = each.name
            nextAnnotation.subtitle = each.phone
            nextAnnotation.coordinate = CLLocationCoordinate2D(latitude: each.lat, longitude: each.long)
            
            self.mapView.addAnnotation(nextAnnotation)
            mapView.setCenter(CLLocationCoordinate2D(latitude: each.lat, longitude: each.long) , animated: true)
            
            let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
            let region = MKCoordinateRegion(center:CLLocationCoordinate2D(latitude: each.lat, longitude: each.long), span:span)
            
            mapView.setRegion(region, animated: true)
            
        }
        
    }


}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.venues.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "venueCell")
            else {return UITableViewCell()}
        
        cell.textLabel?.text = venues[indexPath.row].name
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard (name: "Main", bundle: Bundle.main)
        if let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            vc.selectedVenue = venues[indexPath.row]
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let btn = UIButton(type: .detailDisclosure)
            let annotationView = MKAnnotationView()
            annotationView.image = UIImage(named: "blue-dot")
            annotationView.canShowCallout = true
            annotationView.rightCalloutAccessoryView = btn
            return annotationView
        
        }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let storyboard = UIStoryboard (name: "Main", bundle: Bundle.main)
            if let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
                for venue in venues {
                    if venue.name == (view.annotation?.title)!{
                        vc.selectedVenue = venue
                    }
                }
                navigationController?.pushViewController(vc, animated: true)
            }
            print("right button is tapped")
        }else{
            print("not right button is tapped")
        }
        
    }
    
}
