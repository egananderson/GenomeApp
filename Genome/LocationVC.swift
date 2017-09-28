//
//  LocationVC.swift
//  Genome
//
//  Created by Egan Anderson on 9/18/17.
//  Copyright © 2017 Egan Anderson. All rights reserved.
//

import UIKit
import GoogleMaps

class LocationVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var animationView: AnimationView!
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var blueBackgroundHeight: NSLayoutConstraint!
    
    var showingLoadAnimation = false
    var timer: Timer?
    
    var userController = UserController.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(startAnimation), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        let nib = UINib(nibName: "LocationCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "locationCell")
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.separatorStyle = .none
        
        setupMapView()

        //disable swipe gesture
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startAnimation()
        
        mapView.isHidden = (segmentedControl.selectedSegmentIndex != 0)
    }
    
    func setupMapView() {
        var markers = [GMSMarker]()
        for place in self.userController.currentUser!.location!.taggedPlaces! {
            let latitude: CLLocationDegrees = Double(place.latitude!)!
            let longitude: CLLocationDegrees = Double(place.longitude!)!
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            marker.title = place.name
            marker.snippet = formatDate(dateString: place.timestamp!)
            markers.append(marker)
        }
        
        let camera = GMSCameraPosition.camera(withLatitude: markers[0].position.latitude, longitude: markers[0].position.longitude, zoom: 6.0)
        mapView.camera = camera
        for marker in markers {
            marker.map = mapView
        }

    }
    
    func startAnimation() {
        animationView.startAnimating(color: UIColor(red: 72/255, green: 86/255, blue: 100/255, alpha: 1))
        animationView.alpha = 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "locationCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! LocationCell
        cell.selectionStyle = .none
        
        if let place = self.userController.currentUser?.location?.taggedPlaces?[indexPath.row] {
            cell.nameLabel.text = place.name
            cell.locationLabel.text = "\((place.city ?? "")!), \((place.state ?? "")!), \((place.country ?? "")!)"
            
            cell.timeLabel.text = formatDate(dateString: place.timestamp!)
        }
        
        return cell
    }
    
    func formatDate(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "MST")
        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "EEE, dd MMM yyyy - h:mm a"
        return dateFormatter.string(from: date!)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let places = self.userController.currentUser?.location?.taggedPlaces {
            return places.count
        } else {
            return 0
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentYoffset = scrollView.contentOffset.y
        let newHeight = CGFloat(64) - contentYoffset
        if newHeight > 64 {
            blueBackgroundHeight.constant = newHeight
        }
        
        animationView.alpha = 1/(-70/contentYoffset+0.00001)
        
        if showingLoadAnimation {
            scrollView.setContentOffset(CGPoint(x: 0, y: -70), animated: false)
            //dismiss animation on scroll up
            if contentYoffset > -55 {
                timer?.fire()
            }
        }
        
//        if contentYoffset < -70 && !showingLoadAnimation {
//            showingLoadAnimation = true
//            scrollView.setContentOffset(CGPoint(x: 0, y: -70), animated: true)
//            UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseInOut, animations: {
//                self.animationView.alpha = 1
//            }, completion: nil)
//            
//            //perform refresh
//            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
//                UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
//                    self.userController.updateMusic(){(success)->Void in
//                        if(!success){
//                            print("not all music talbes updated")
//                        }
//                        self.tableView.reloadData()
//                        self.showingLoadAnimation = false
//                        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
//                    }
//                }, completion: nil)
//            }
//        }
    }
    
    @IBAction func segmentedControlSwitched(_ sender: Any) {
        mapView.isHidden = (segmentedControl.selectedSegmentIndex != 0)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
