//
//  AccountManagerVC.swift
//  Genome
//
//  Created by Egan Anderson on 4/19/17.
//  Copyright © 2017 Egan Anderson. All rights reserved.
//

import UIKit

class AccountManagerVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var blueBackgroundHeight: NSLayoutConstraint!
    @IBOutlet var animationView: AnimationView!
    var showingLoadAnimation = false
    var timer: Timer?
    
    let userController = UserController.sharedInstance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(startAnimation), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)

        let nib = UINib(nibName: "AccountManagerCell", bundle: nil)
        let nib2 = UINib(nibName: "DataCategoryCellTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "accountCell")
        self.tableView.register(nib2, forCellReuseIdentifier: "settingsCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.separatorStyle = .none
        
        let nib3 = UINib(nibName: "SectionHeaderView", bundle: nil)
        self.tableView.register(nib3, forHeaderFooterViewReuseIdentifier: "sectionHeaderView")
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
        switch section {
        case 0:
            //accountsTableView
            header.titleLabel.text = "My Accounts"
            header.button.isHidden = false
            header.buttonImageView.isHidden = false
            header.button.addTarget(self, action: #selector(addAccountButtonPressed), for: .touchUpInside)
        case 1:
            //appsTableView
            header.titleLabel.text = "Apps Using My Data"
            header.button.isHidden = true
        default:
            header.titleLabel.text = "My Settings"
            header.button.isHidden = true
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            if (userController.currentUser?.accounts?.count)! > 0 {
                return 44
            }
        case 1:
            if (userController.currentUser?.apps?.count)! > 0 {
                return 44
            }
        default:
            return 0
        }
        return 84
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            //accountsTableView
            let cellID = "accountCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! AccountManagerCell
            let accountName = userController.currentUser?.accounts?[indexPath.row]
            cell.titleLabel.text = accountName
            userController.getUserAllowedPermissionsForAccount(userToken: (userController.currentUser?.userID)!, accountName: accountName!){
                (success, error) -> () in
                if(!success) {
                   print(error as Any)
                }
            }
            return cell
        case 1:
            //appsTableView
            let cellID = "accountCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! AccountManagerCell
            let appName = userController.currentUser?.apps?[indexPath.row]
            cell.titleLabel.text = appName
            userController.getUserAllowedScopesForApp(userToken: (userController.currentUser?.userID)!, appName: appName!){(success, error)-> () in
                if(!success) {
                    print(error as Any)
                }
            }
            return cell
        default:
            //appsTableView
            let cellID = "settingsCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! DataCategoryCellTableViewCell
            cell.arrowImageView.isHidden = true
            switch indexPath.row {
            case 0:
                cell.nameLabel.text = "Log out"
            case 1:
                cell.nameLabel.text = "Reset password"
            default:
                cell.nameLabel.text = "Delete account"
            }
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            //accountsTableView
            return (userController.currentUser?.accounts?.count)!
        case 1:
            return (userController.currentUser?.apps?.count)!
        default:
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            userController.currentAccount = userController.currentUser?.accounts?[indexPath.row]
            let editAccountPermissions = EditAccountPermissions()
            self.navigationController?.pushViewController(editAccountPermissions, animated: true)
        case 1:
            userController.currentApp = userController.currentUser?.apps?[indexPath.row]
            let editAppAccessVC = EditAppAccessVC()
            self.navigationController?.pushViewController(editAppAccessVC, animated: true)
        default:
            switch indexPath.row {
            case 0:
                userController.logout()
                OperationQueue.main.addOperation {
                    var viewCtonrollers = self.navigationController?.viewControllers
                    let firstViewCtr = SplashVC()
                    viewCtonrollers?.removeAll()
                    viewCtonrollers?.insert(firstViewCtr, at: 0)
                    self.navigationController?.viewControllers = viewCtonrollers!
                }
                break
            case 1:
                //TODO: - Reset Password
                break
            default:
                //TODO: - Delete Account
                break
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
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
                    self.userController.addPermissionsInfo(){() -> () in
                        self.tableView.reloadData()
                        self.showingLoadAnimation = false
                        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                    }
                }, completion: nil)
            }
        }
    }
    
    func addAccountButtonPressed() {
        let linkAccountsVC = LinkAccountsVC()
        self.navigationController?.pushViewController(linkAccountsVC, animated: true)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
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
