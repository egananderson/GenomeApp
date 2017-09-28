//
//  EditAppAccessVC.swift
//  Genome
//
//  Created by Egan Anderson on 4/19/17.
//  Copyright © 2017 Egan Anderson. All rights reserved.
//

import UIKit

class EditAppAccessVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var blueBackgroundHeight: NSLayoutConstraint!
    @IBOutlet var animationView: AnimationView!
    var showingLoadAnimation = false
    var timer: Timer?
    
    var permissionIndex = 0 //Used to get names out of dict for the rows
    
    let userController = UserController.sharedInstance


    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(startAnimation), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)

        let nib = UINib(nibName: "SwitchCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "switchCell")
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.separatorStyle = .none
        
        let nib2 = UINib(nibName: "SectionHeaderView", bundle: nil)
        self.tableView.register(nib2, forHeaderFooterViewReuseIdentifier: "sectionHeaderView")
        
        self.titleLabel.text = userController.currentApp
        
        permissionIndex = 0
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
        header.titleLabel.text = "Edit Access"
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "switchCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! SwitchCell
        let cellName = userController.currentUser?.scopesForApp?[userController.currentApp!]?[permissionIndex]
        cell.titleLabel.text = cellName
        permissionIndex += 1
        
        if(userController.currentUser?.scopesStatus?[userController.currentApp!]?[cellName!] == nil){
            userController.currentUser?.scopesStatus?[userController.currentApp!]?[cellName!] = false
        }
        
        if(userController.currentUser?.scopesStatus?[userController.currentApp!]?[cellName!])!{
            cell.switchToggle.setOn(true, animated: true)
        } else {
            cell.switchToggle.setOn(false, animated: true)
        }
        cell.switchToggle.tag = indexPath.row
        cell.switchToggle.addTarget(self, action: #selector(toggleSwitch(_:)), for: .touchUpInside)
        cell.selectionStyle = .none
        
        if(permissionIndex == userController.currentUser?.scopesForApp?[userController.currentApp!]?.count){
            permissionIndex = 0
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = (userController.currentUser?.scopesForApp![userController.currentApp!]?.count)!
        return count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
                    self.userController.getUserAllowedScopesForApp(userToken: (self.userController.currentUser?.userID)!, appName: self.userController.currentApp!){(success, error) -> () in
                        if(!success){
                            print(error as Any)
                        }else {
                            self.tableView.reloadData()
                        }
                        self.showingLoadAnimation = false
                        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                    }
                }, completion: nil)
            }
        }
    }
    
    func toggleSwitch(_ sender: UIButton) {
        let cell = self.tableView.cellForRow(at: IndexPath(row: sender.tag , section: 0)) as! SwitchCell
        let key = cell.titleLabel.text
        userController.currentUser?.scopesStatus?[userController.currentApp!]?[key!] = !(userController.currentUser?.scopesStatus?[userController.currentApp!]?[key!])!
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        let app = userController.currentApp
        let scopes = userController.currentUser?.scopesStatus?[app!]?.keys
        for key in scopes! {
            if(userController.currentUser?.scopesStatus?[app!]?[key])!{
                userController.addUserAllowedScopesForApp(userToken: (userController.currentUser?.userID)!, appName: app!, scopeName: key)
            } else {
                userController.removeUserAllowedScopesForApp(userToken: (userController.currentUser?.userID)!, appName: app!, scopeName: key)
            }
        }
        
        self.navigationController?.popViewController(animated: true)
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
