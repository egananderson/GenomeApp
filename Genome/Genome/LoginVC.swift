//
//  LoginVC.swift
//  Genome
//
//  Created by Egan Anderson on 3/28/17.
//  Copyright © 2017 Egan Anderson. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet var usernameBackground: UIImageView!
    @IBOutlet var usernameText: UITextField!
    
    @IBOutlet var passwordBackground: UIImageView!
    @IBOutlet var passwordText: UITextField!
    
    @IBOutlet var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameBackground.image = nil
        usernameBackground.backgroundColor = UIColor.white
        usernameBackground.layer.cornerRadius = usernameBackground.frame.height/2
        usernameBackground.clipsToBounds = true
        
        passwordBackground.image = nil
        passwordBackground.backgroundColor = UIColor.white
        passwordBackground.layer.cornerRadius = passwordBackground.frame.height/2
        passwordBackground.clipsToBounds = true
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: logInButton.frame.width+1, height: logInButton.frame.height)
        gradient.backgroundColor = UIColor.red.cgColor
        gradient.colors = [UIColor.init(red: 95.0/255, green: 213.0/255, blue: 142.0/255, alpha: 1).cgColor, UIColor.init(red: 72.0/255, green: 185.0/255, blue: 233.0/255, alpha: 1).cgColor]
        gradient.startPoint = .zero
        gradient.endPoint = .init(x: 1, y: 0)
        logInButton.setBackgroundImage(nil, for: .normal)
        logInButton.layer.addSublayer(gradient)
        logInButton.layer.cornerRadius = logInButton.frame.height/2
        logInButton.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if(!(usernameText.text?.isEmpty)! && !(passwordText.text?.isEmpty)!){
            let userController = UserController.sharedInstance
            userController.loginUser(email: usernameText.text!, password: passwordText.text!){ (success, error) -> () in
                if (success) {
                    OperationQueue.main.addOperation {
                        let dataDnaVC = DataDNAVC()
                        self.navigationController?.pushViewController(dataDnaVC, animated: true)
                    }
                } else {
                    print("Error durring login " + error.debugDescription)
                }
            }
        }
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
