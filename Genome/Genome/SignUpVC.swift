//
//  SignUpVC.swift
//  Genome
//
//  Created by Egan Anderson on 3/28/17.
//  Copyright © 2017 Egan Anderson. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {

    @IBOutlet var usernameBackground: UIImageView!
    
    @IBOutlet var password1Background: UIImageView!
    
    @IBOutlet var password2Background: UIImageView!
    
    @IBOutlet var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameBackground.image = nil
        usernameBackground.backgroundColor = UIColor.white
        usernameBackground.layer.cornerRadius = usernameBackground.frame.height/2
        usernameBackground.clipsToBounds = true
        
        password1Background.image = nil
        password1Background.backgroundColor = UIColor.white
        password1Background.layer.cornerRadius = password1Background.frame.height/2
        password1Background.clipsToBounds = true
        
        password2Background.image = nil
        password2Background.backgroundColor = UIColor.white
        password2Background.layer.cornerRadius = password2Background.frame.height/2
        password2Background.clipsToBounds = true

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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        let linkAccountsVC = LinkAccountsVC()
        self.navigationController?.pushViewController(linkAccountsVC, animated: true)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
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
