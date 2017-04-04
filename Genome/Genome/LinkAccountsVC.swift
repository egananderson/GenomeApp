//
//  LinkAccountsVC.swift
//  Genome
//
//  Created by Egan Anderson on 4/3/17.
//  Copyright © 2017 Egan Anderson. All rights reserved.
//

import UIKit

class LinkAccountsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var containerView: UIView!
    
    @IBOutlet var gradientStripeView: UIView!
    
    @IBOutlet var stripeImageView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            cell.logoImage.image = UIImage(named: "facebook_gray")
        case 1:
            cell.logoImage.image = UIImage(named: "google_gray")
        case 2:
            cell.logoImage.image = UIImage(named: "spotify_gray")
        default:
            cell.logoImage.image = UIImage(named: "pinterest_gray")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
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
