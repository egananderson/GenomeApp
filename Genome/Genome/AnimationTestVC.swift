//
//  AnimationTestVC.swift
//  Genome
//
//  Created by Egan Anderson on 4/20/17.
//  Copyright © 2017 Egan Anderson. All rights reserved.
//

import UIKit

class AnimationTestVC: UIViewController {

    @IBOutlet var animationView: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red: 40/255, green: 47/255, blue: 62/255, alpha: 1)
        let animationController = AnimationController.init()
        animationController.startAnimation(animationView: animationView, color: UIColor(red: 40/255, green: 47/255, blue: 62/255, alpha: 1))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
