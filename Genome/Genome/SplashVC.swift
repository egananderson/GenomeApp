//
//  SplashVC.swift
//  Genome
//
//  Created by Egan Anderson on 3/27/17.
//  Copyright © 2017 Egan Anderson. All rights reserved.
//

import UIKit

class SplashVC: UIViewController {
    
    @IBOutlet var signUpButton: UIButton!
    
    @IBOutlet var logInButton: UIButton!
    
    @IBOutlet var facebookButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: signUpButton.frame.width+1, height: signUpButton.frame.height)
        gradient.backgroundColor = UIColor.red.cgColor
        gradient.colors = [UIColor.init(red: 95.0/255, green: 213.0/255, blue: 142.0/255, alpha: 1).cgColor, UIColor.init(red: 72.0/255, green: 185.0/255, blue: 233.0/255, alpha: 1).cgColor]
        gradient.startPoint = .zero
        gradient.endPoint = .init(x: 1, y: 0)
        signUpButton.setBackgroundImage(nil, for: .normal)
        signUpButton.layer.addSublayer(gradient)
        signUpButton.layer.cornerRadius = signUpButton.frame.height/2
        signUpButton.clipsToBounds = true
        
        let gradient2 = CAGradientLayer()
        gradient2.frame = CGRect(x: 0, y: 0, width: signUpButton.frame.width+1, height: signUpButton.frame.height)
        gradient2.backgroundColor = UIColor.red.cgColor
        gradient2.colors = [UIColor.init(red: 95.0/255, green: 213.0/255, blue: 142.0/255, alpha: 1).cgColor, UIColor.init(red: 72.0/255, green: 185.0/255, blue: 233.0/255, alpha: 1).cgColor]
        gradient2.startPoint = .zero
        gradient2.endPoint = .init(x: 1, y: 0)
        logInButton.setBackgroundImage(nil, for: .normal)
        logInButton.layer.addSublayer(gradient2)
        logInButton.layer.cornerRadius = logInButton.frame.height/2
        logInButton.clipsToBounds = true
        
        facebookButton.setBackgroundImage(nil, for: .normal)
        facebookButton.backgroundColor = UIColor.init(red: 64.0/255, green: 93.0/255, blue: 147.0/255, alpha: 1)
        facebookButton.layer.cornerRadius = facebookButton.frame.height/2
        facebookButton.clipsToBounds = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        let signUpVC = SignUpVC()
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @IBAction func logInPressed(_ sender: UIButton) {
        let loginVC = LoginVC()
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    @IBAction func logInFacebookPressed(_ sender: UIButton) {
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
