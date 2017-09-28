//
//  ExperienceVC.swift
//  Genome
//
//  Created by Egan Anderson on 9/18/17.
//  Copyright © 2017 Egan Anderson. All rights reserved.
//

import UIKit

class ExperienceVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var animationView: AnimationView!
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
        
        let nib2 = UINib(nibName: "SectionHeaderView", bundle: nil)
        self.tableView.register(nib2, forHeaderFooterViewReuseIdentifier: "sectionHeaderView")
        
        let nib3 = UINib(nibName: "ExperienceCell", bundle: nil)
        tableView.register(nib3, forCellReuseIdentifier: "experienceCell")
        
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeaderView")
        let header = cell as! SectionHeaderView

        header.button.isHidden = true
        header.buttonImageView.isHidden = true
        
        switch section {
        case 0:
            if (self.userController.currentUser?.experience?.education != nil &&
                (self.userController.currentUser?.experience?.education?.count)! > 0) {
                header.titleLabel.text = "Education"
            } else {
                header.titleLabel.text = "Work"
            }
            break
        default:
            header.titleLabel.text = "Work"
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
            //needs to change because 0 isn't always education
        case 0:
            return 76
        default:
            return 90
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if (self.userController.currentUser?.experience?.education != nil &&
                (self.userController.currentUser?.experience?.education?.count)! > 0) {
                //education
                let education = (self.userController.currentUser?.experience?.education?[indexPath.row])!
                let cellID = "locationCell"
                let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! LocationCell
                cell.selectionStyle = .none
                cell.nameLabel.text = education.school
                cell.locationLabel.text = education.degree
                cell.timeLabel.text = education.year
                //                cell.locationLabel.text = "\((place.city ?? "")!), \((place.state ?? "")!), \((place.country ?? "")!)"
                //                let dateFormatter = DateFormatter()
                //                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                //                dateFormatter.timeZone = TimeZone(abbreviation: "MST")
                //                let date = dateFormatter.date(from: place.timestamp!)
                //                dateFormatter.dateFormat = "MMM yyyy"
                //                let dateString = dateFormatter.string(from: date!)
                //                cell.timeLabel.text = dateString
                return cell
            } else {
                //work
                let work = (self.userController.currentUser?.experience?.work?[indexPath.row])!
                let cellID = "experienceCell"
                var cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ExperienceCell
                cell.selectionStyle = .none
                cell.nameLabel.text = work.businessName
                cell.jobTitleLabel.text = work.position
                cell.locationLabel.text = "\(work.city ?? ""), \(work.state ?? "")"
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                dateFormatter.timeZone = TimeZone(abbreviation: "MST")
                if work.startDate != nil {
                    var date = dateFormatter.date(from: work.startDate!)
                    dateFormatter.dateFormat = "MMM yyyy"
                    var dateString = dateFormatter.string(from: date!)
                    cell.timeLabel.text = dateString
                    if work.endDate != nil {
                        date = dateFormatter.date(from: work.endDate!)
                        dateFormatter.dateFormat = "MMM yyyy"
                        dateString = dateFormatter.string(from: date!)
                        cell.timeLabel.text = "\(cell.timeLabel.text) - \(dateString)"
                        
                    } else {
                        cell.timeLabel.text = "\(cell.timeLabel.text) - present"
                    }
                }
                return cell
            }
            
        default:
            //work
            let work = (self.userController.currentUser?.experience?.work?[indexPath.row])!
            let cellID = "experienceCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ExperienceCell
            cell.selectionStyle = .none
            cell.nameLabel.text = work.businessName
            cell.jobTitleLabel.text = work.position
            cell.locationLabel.text = "\(work.city ?? ""), \(work.state ?? "")"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            dateFormatter.timeZone = TimeZone(abbreviation: "MST")
            if work.startDate != nil {
                var date = dateFormatter.date(from: work.startDate!)
                dateFormatter.dateFormat = "MMM yyyy"
                var dateString = dateFormatter.string(from: date!)
                cell.timeLabel.text = dateString
                if work.endDate != nil {
                    date = dateFormatter.date(from: work.endDate!)
                    dateFormatter.dateFormat = "MMM yyyy"
                    dateString = dateFormatter.string(from: date!)
                    cell.timeLabel.text = "\(cell.timeLabel.text) - \(dateString)"
                    
                } else {
                    cell.timeLabel.text = "\(cell.timeLabel.text) - present"
                }
            }
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.userController.currentUser?.experience?.education != nil &&
            self.userController.currentUser?.experience?.work != nil &&
            (self.userController.currentUser?.experience?.education?.count)! > 0 &&
            (self.userController.currentUser?.experience?.work?.count)! > 0 {
            return 2
        } else if (self.userController.currentUser?.experience?.education != nil &&
            (self.userController.currentUser?.experience?.education?.count)! > 0) ||
            (self.userController.currentUser?.experience?.education != nil &&
                (self.userController.currentUser?.experience?.work?.count)! > 0) {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let experience = self.userController.currentUser?.experience
        switch section {
        case 0:
            if (experience?.education != nil &&
                (experience?.education!.count)! > 0) {
                return (experience!.education?.count)!
            } else {
                return (experience!.work?.count)!
            }
        default:
            return (experience!.work?.count)!
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
        //    }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
