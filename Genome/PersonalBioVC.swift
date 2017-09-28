//
//  PersonalBioVC.swift
//  Genome
//
//  Created by Egan Anderson on 9/17/17.
//  Copyright © 2017 Egan Anderson. All rights reserved.
//

import UIKit

class PersonalBioVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var animationView: AnimationView!
    @IBOutlet var blueBackgroundHeight: NSLayoutConstraint!
    var showingLoadAnimation = false
    var timer: Timer?
    
    var userController = UserController.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(startAnimation), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        let nib = UINib(nibName: "BioCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "bioCell")
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.separatorStyle = .none
        
        //disable swipe gesture
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startAnimation()
    }
    
    func startAnimation() {
        animationView.startAnimating(color: UIColor(red: 72/255, green: 86/255, blue: 100/255, alpha: 1))
        animationView.alpha = 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "bioCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! BioCell
        cell.selectionStyle = .none
        
        let bio = self.userController.currentUser?.bio
        if let category: Bio.BioCategory = bio?.subCategories?[indexPath.row] {
            switch category {
            case .firstName:
                cell.title.text = "First Name"
                cell.value.text = bio?.firstName
                break
            case .middleName:
                cell.title.text = "Middle Name"
                cell.value.text = bio?.middleName
                break
            case .lastName:
                cell.title.text = "Last Name"
                cell.value.text = bio?.lastName
                break
            case .fullName:
                cell.title.text = "Full Name"
                cell.value.text = bio?.fullName
                break
            case .nameFormat:
                cell.title.text = "Name Format"
                cell.value.text = bio?.nameFormat
                break
            case .shortName:
                cell.title.text = "Short Name"
                cell.value.text = bio?.shortName
                break
            case .gender:
                cell.title.text = "Gender"
                cell.value.text = bio?.gender
                break
            case .email:
                cell.title.text = "Email"
                cell.value.text = bio?.email
                break
            case .birthday:
                cell.title.text = "Birthday"
                cell.value.text = bio?.birthday
                break
            case .about:
                cell.title.text = "About"
                cell.value.text = bio?.about
                break
            case .hometown:
                cell.title.text = "Hometown"
                cell.value.text = bio?.hometown
                break
            case .currentLocation:
                cell.title.text = "Current Location"
                cell.value.text = bio?.currentLocation
                break
            case .relationshipStatus:
                cell.title.text = "Relationship Status"
                cell.value.text = bio?.relationshipStatus
                break
            case .currency:
                cell.title.text = "Curency"
                cell.value.text = bio?.currency
                break
            case .religion:
                cell.title.text = "Religion"
                cell.value.text = bio?.religion
                break
            case .politics:
                cell.title.text = "Politics"
                cell.value.text = bio?.politics
                break
            case .website:
                cell.title.text = "Website"
                cell.value.text = bio?.website
                break
            case .quotes:
                cell.title.text = "Quotes"
                cell.value.text = bio?.quotes
                break
            case .languages:
                if let languages = bio?.languages {
                    cell.title.text = "Languages"
                    var languagesValue = ""
                    for i in 0 ..< languages.count {
                        if (i < languages.count - 1) {
                            //has comma
                            languagesValue = "\(languagesValue)\(languages[i]), "
                        } else {
                            //no comma
                            languagesValue = "\(languagesValue)\(languages[i])"
                        }
                    }
                    cell.value.text = languagesValue
                    break
                } else {
                    break
                }
            }
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        for _: Bio.BioCategory in (self.userController.currentUser?.bio?.subCategories)! {
            count += 1
        }
        return count
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
   
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
