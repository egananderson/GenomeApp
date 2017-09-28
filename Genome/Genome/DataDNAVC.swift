//
//  DataDNAVC.swift
//  Genome
//
//  Created by Egan Anderson on 4/6/17.
//  Copyright © 2017 Egan Anderson. All rights reserved.
//

import UIKit

class DataDNAVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var blueBackgroundHeight: NSLayoutConstraint!    
    @IBOutlet var animationView: AnimationView!
    var showingLoadAnimation = false
    var timer: Timer?
    
    var userController = UserController.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(startAnimation), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        self.startAnimation()
        
        //GET INFO FROM SERVER (FIND BETTER PLACE??)
        self.userController.addPermissionsInfo(completionHandler:{})
        self.userController.addDataCategories()
        self.userController.addSubDataCategories()
        
        let nib = UINib(nibName: "DataCategoryCellTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "categoryCell")

        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.separatorStyle = .none
        
        let nib2 = UINib(nibName: "SectionHeaderView", bundle: nil)
        self.tableView.register(nib2, forHeaderFooterViewReuseIdentifier: "sectionHeaderView")
        
        self.navigationController?.setViewControllers([self], animated: false)
        
        //disable swipe gesture
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startAnimation()
    }
    
    func startAnimation() {
        animationView.startAnimating(color: UIColor(red: 72/255, green: 86/255, blue: 100/255, alpha: 1))
        animationView.alpha = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeaderView")
        let header = cell as! SectionHeaderView
        header.titleLabel.text = "My Data DNA"
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "categoryCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! DataCategoryCellTableViewCell
        let userController = UserController.sharedInstance
        cell.nameLabel.text = userController.currentUser?.dataCategories?[indexPath.row].name
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if userController.currentUser?.dataCategories != nil {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let categories = userController.currentUser?.dataCategories {
            return categories.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        // this whole thing is hard coded to work for the demo. should be changed.
        switch indexPath.row {
        case 0:
            //display bio
            if (self.userController.currentUser?.bio) != nil {
            } else {
                self.userController.currentUser?.bio = Bio()
            }
            let bioVC = PersonalBioVC()
            self.navigationController?.pushViewController(bioVC, animated: true)
            break
        case 1:
            //display location
            if (self.userController.currentUser?.location) != nil {
            } else {
                self.userController.currentUser?.location = Location()
            }
            let locationVC = LocationVC()
            self.navigationController?.pushViewController(locationVC, animated: true)
            break
        case 2:
            //display entertainment
            let currentCategory = userController.currentUser?.dataCategories?[indexPath.row]
            userController.currentDataCategory = currentCategory
            let dataCategoryVC = DataCategoryVC()
            self.navigationController?.pushViewController(dataCategoryVC, animated: true)
            break
        case 3:
            //display social media
            let socialVC = SocialVC()
            self.navigationController?.pushViewController(socialVC, animated: true)
            break
        case 4:
            //display experience
            let experienceVC = ExperienceVC()
            self.navigationController?.pushViewController(experienceVC, animated: true)
            break
        case 5:
            //display sports
            let currentCategory = userController.currentUser?.dataCategories?[indexPath.row]
            userController.currentDataCategory = currentCategory
            let dataCategoryVC = DataCategoryVC()
            self.navigationController?.pushViewController(dataCategoryVC, animated: true)
            break
        default:
            return
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
        
        if contentYoffset < -70 && !showingLoadAnimation {
            showingLoadAnimation = true
            scrollView.setContentOffset(CGPoint(x: 0, y: -70), animated: true)
            UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseInOut, animations: {
                self.animationView.alpha = 1
            }, completion: nil)
            
            //perform refresh
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
                UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
                    self.userController.updateMusic(){(success)->Void in
                        if(!success){
                            print("not all music data updated")
                        }
                        self.tableView.reloadData()
                        self.showingLoadAnimation = false
                        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                    }
                }, completion: nil)
            }
        }
    }
    
    @IBAction func profileButtonPressed(_ sender: Any) {
        let accountManagerVC = AccountManagerVC()
        self.navigationController?.pushViewController(accountManagerVC, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
