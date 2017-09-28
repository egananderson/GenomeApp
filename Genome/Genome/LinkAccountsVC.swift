//
//  LinkAccountsVC.swift
//  Genome
//
//  Created by Egan Anderson on 4/3/17.
//  Copyright © 2017 Egan Anderson. All rights reserved.
//

import UIKit
import SafariServices

class LinkAccountsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, OAuthIODelegate {

    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var containerView: UIView!
    
    @IBOutlet var gradientStripeView: UIView!
    
    @IBOutlet var stripeImageView: UIImageView!
    
    @IBOutlet var loadingView: UIView!
    
    @IBOutlet var animationView: AnimationView!
    
    @IBOutlet var continueButton: UIButton!
    
    var accountWasAdded = false
    var accountLinking = ""
    
    let accountController = AccountController.sharedInstance
    let userController = UserController.sharedInstance
        
    var oauthioModal: OAuthIOModal?
    let oauthKey = "4GQzipc_uhXaiLgoKViHp6vM2Eg"
    let oauthOptions = NSMutableDictionary()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(startAnimation), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        userController.load()
        self.oauthioModal = OAuthIOModal(key: oauthKey, delegate: self)
        self.oauthioModal?.clearCache()
        self.oauthOptions.setValue("true", forKey: "cache")
        
        let nib = UINib(nibName: "LinkAccountsCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "accountCell")
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.separatorStyle = .none
        
        self.containerView.layer.cornerRadius = 15.0
        self.containerView.clipsToBounds = true
        
        let gradient = CAGradientLayer()
        gradient.frame = self.gradientStripeView.bounds
        gradient.backgroundColor = UIColor.red.cgColor
        gradient.colors = [UIColor.init(red: 95.0/255, green: 213.0/255, blue: 142.0/255, alpha: 1).cgColor, UIColor.init(red: 72.0/255, green: 185.0/255, blue: 233.0/255, alpha: 1).cgColor]
        gradient.startPoint = .zero
        gradient.endPoint = .init(x: 1, y: 0)
        self.gradientStripeView.layer.addSublayer(gradient)
        
        self.stripeImageView.backgroundColor = .clear
        
        self.navigationController?.navigationBar.isHidden = true
    
        NotificationCenter.default.addObserver(self, selector: #selector(LinkAccountsVC.refresh), name: NSNotification.Name(rawValue: "refreshAccountList"), object: nil)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        if self.presentingViewController != nil {
            self.continueButton.titleLabel?.text = "Done"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startAnimation()
    }
    
    func startAnimation() {
        self.animationView.startAnimating(color: UIColor(red: 53/255, green: 62/255, blue: 80/255, alpha: 1))
    }
    
    func refresh() {
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "accountCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! LinkAccountsCell
        
        switch indexPath.row {
        case 0:
            cell.account = self.accountController.allAccounts?[0]
        case 1:
            cell.account = self.accountController.allAccounts?[1]
        case 2:
            cell.account = self.accountController.allAccounts?[2]
        default:
            cell.account = self.accountController.allAccounts?[3]
        }
        
        for acccount in (self.userController.currentUser?.accounts)!{
            if cell.account?.accountType == acccount{
                cell.account?.isUpToDate = true
            }
        }
        
        cell.formatCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            self.accountLinking = "facebook"
        case 1:
            self.accountLinking = "google"
        case 2:
            self.accountLinking = "spotify"
        case 3:
            self.accountLinking = "pinterest"
        default:
            return
        }
        self.oauthioModal?.show(withProvider: self.accountLinking, options: self.oauthOptions as [NSObject :AnyObject])
    }
    
    
    @IBAction func continueButtonPressed(_ sender: UIButton) {   
        //Dismiss immediately if no accounts added, otherwise do animation
        if !accountWasAdded {
            if self.presentingViewController != nil{
                self.dismiss(animated: true, completion: nil)
            } else {
                let dataDnaVC = DataDNAVC()
                self.navigationController?.pushViewController(dataDnaVC, animated: true)
            }
        } else {
            self.loadingView.alpha = 0
            self.view.bringSubview(toFront: loadingView)
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.loadingView.alpha = 1
            }, completion: nil)
            
            // delete this timer and push the vc once the networking request is complete
            _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                if self.presentingViewController != nil{
                    self.dismiss(animated: true, completion: nil)
                } else {
                    let dataDnaVC = DataDNAVC()
                    self.navigationController?.pushViewController(dataDnaVC, animated: true)
                }
            }

        }
    }
    
    //MARK: - OAuth Delegates
    
    func didReceiveOAuthIOCode(_ code: String!) {
        print("didReceiveOAuthIOCode")
        return
    }
    
    func didAuthenticateServerSide(_ body: String!, andResponse response: URLResponse!) {
        print("didAuthenticateServerSide")
        return
    }
    
    func didReceiveOAuthIOResponse(_ request: OAuthIORequest!) {
        var cred: Dictionary = request.getCredentials()
        
        //        For OAuth 2
        //        print(cred["access_token"]!)
        //        For OAuth 1
        //        print(cred["oauth_token"])
        //        print(cred["oauth_token_secret "])
        //        print(request.getCredentials())
        let token = cred["access_token"] as! String
        accountWasAdded = true
        accountController.connectAccount(type: self.accountLinking, token:token)
        var tokens = userController.oauthTokens[(userController.currentUser?.userID)!]
        if (tokens == nil) {
            tokens = [:]
        }
        tokens?[self.accountLinking] = token
        userController.oauthTokens[(userController.currentUser?.userID)!] = tokens
        userController.save()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshAccountList"), object: nil)
        return
    }
    
    func didFail(withOAuthIOError error: Error!) {
        print("didFailwithOAuthIOError")
        return
    }
    
    func didFailAuthenticationServerSide(_ body: String!, andResponse response: URLResponse!, andError error: Error!) {
        print("didFailAuthenticationServerSide")
        return
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
