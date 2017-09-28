//
//  SocialVC.swift
//  Genome
//
//  Created by Egan Anderson on 9/18/17.
//  Copyright © 2017 Egan Anderson. All rights reserved.
//

import UIKit

class SocialVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var animationView: AnimationView!
    @IBOutlet var blueBackgroundHeight: NSLayoutConstraint!
    
    var showingLoadAnimation = false
    var timer: Timer?
    
    var userController = UserController.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(startAnimation), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        let nib = UINib(nibName: "SocialCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "socialCell")
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.separatorStyle = .none
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 0
        if let post = self.userController.currentUser?.social?.posts?[indexPath.row] {
            if (post.message != nil) && (post.story != nil) {
                height = getTextHeight(text: post.message!, fontSize: 17) + getTextHeight(text: post.story!, fontSize: 13) + 60
            } else if post.message != nil {
                height = getTextHeight(text: post.message!, fontSize: 17) + 50
            } else if post.story != nil {
                height = getTextHeight(text: post.story!, fontSize: 17) + 50
            }
        }
        return height
    }
    
    func getTextHeight(text: String, fontSize: CGFloat) -> CGFloat {
        let attributedString = getParagraphStyle(text: text)
        let testLabel = UILabel()
        testLabel.attributedText = attributedString
        testLabel.numberOfLines = 0
        testLabel.font = UIFont(name: "Arial", size: fontSize)
        let minimumSize = CGSize(width: tableView.frame.width-27, height: 9999)
        let expectedSize = testLabel.sizeThatFits(minimumSize)
        return expectedSize.height
    }
    
    func getParagraphStyle(text: String) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        let attributedString = NSMutableAttributedString(string: text)
        let lengthOfString = text.characters.count
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: lengthOfString))
        return attributedString
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "socialCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! SocialCell
        cell.selectionStyle = .none
        cell.contentLabel.numberOfLines = 0
        cell.contentLabel.lineBreakMode = .byWordWrapping
        cell.detail1Label.numberOfLines = 0
        cell.detail1Label.lineBreakMode = .byWordWrapping
        
        if let post = self.userController.currentUser?.social?.posts?[indexPath.row] {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            dateFormatter.timeZone = TimeZone(abbreviation: "MST")
            let date = dateFormatter.date(from: post.timestamp!)
            dateFormatter.dateFormat = "EEE, dd MMM yyyy - h:mm a"
            let dateString = dateFormatter.string(from: date!)
            
            if (post.message != nil) && (post.story != nil) {
                cell.contentLabel.attributedText = getParagraphStyle(text: post.message!)
                cell.contentLabel.frame = CGRect(x: 0, y: 0, width: cell.contentLabel.frame.width, height: getTextHeight(text: post.message!, fontSize: 17))
                cell.detail1Label.attributedText = getParagraphStyle(text: post.story!)
                cell.detail1Label.frame = CGRect(x: 0, y: 0, width: cell.detail1Label.frame.width, height: getTextHeight(text: post.story!, fontSize: 13))
                cell.detail2Label.text = dateString
            } else if (post.message != nil) {
                cell.contentLabel.attributedText = getParagraphStyle(text: post.message!)
                cell.contentLabel.frame = CGRect(x: 0, y: 0, width: cell.contentLabel.frame.width, height: getTextHeight(text: post.message!, fontSize: 17))
                cell.detail1Label.text = dateString
                cell.detail2Label.text = ""
            } else {
                cell.contentLabel.attributedText = getParagraphStyle(text: post.story!)
                cell.contentLabel.frame = CGRect(x: 0, y: 0, width: cell.contentLabel.frame.width, height: getTextHeight(text: post.story!, fontSize: 17))
                cell.detail1Label.text = dateString
                cell.detail2Label.text = ""
            }
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let places = self.userController.currentUser?.location?.taggedPlaces {
            return places.count
        } else {
            return 0
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
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
