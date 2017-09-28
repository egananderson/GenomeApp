//
//  DataCategoryVC.swift
//  Genome
//
//  Created by Egan Anderson on 4/11/17.
//  Copyright © 2017 Egan Anderson. All rights reserved.
//

import UIKit

class DataCategoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var navBarTitleLabel: UILabel!
    @IBOutlet var blueBackgroundHeight: NSLayoutConstraint!
    @IBOutlet var animationView: AnimationView!
    var showingLoadAnimation = false
    var timer: Timer?
    var showMore0 = false
    var showMore1 = false
    var showMore2 = false
    var showMore3 = false
    var showMore4 = false
    var showMore5 = false
    
    var userController = UserController.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(startAnimation), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        let nib = UINib(nibName: "MusicCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "musicCell")
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.separatorStyle = .none
        
        let nib2 = UINib(nibName: "SectionHeaderView", bundle: nil)
        self.tableView.register(nib2, forHeaderFooterViewReuseIdentifier: "sectionHeaderView")
        
        self.navBarTitleLabel.text = userController.currentDataCategory?.name

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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let userController = UserController.sharedInstance
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeaderView")
        let header = cell as! SectionHeaderView
        header.titleLabel.text = userController.currentDataCategory?.subCategories?[section].name
        header.button.isHidden = false
        header.buttonImageView.isHidden = false
        header.button.addTarget(self, action: #selector(showMoreLessButtonPressed(_:)), for: .touchUpInside)
        switch section {
        case 0:
            header.button.tag = 0
            if showMore0 {
                header.buttonImageView.image = UIImage(named: "arrow_up")
            } else {
                header.buttonImageView.image = UIImage(named: "arrow_down")
            }
        case 1:
            header.button.tag = 1
            if showMore1 {
                header.buttonImageView.image = UIImage(named: "arrow_up")
            } else {
                header.buttonImageView.image = UIImage(named: "arrow_down")
            }
        case 2:
            header.button.tag = 2
            if showMore2 {
                header.buttonImageView.image = UIImage(named: "arrow_up")
            } else {
                header.buttonImageView.image = UIImage(named: "arrow_down")
            }
        case 3:
            header.button.tag = 3
            if showMore3 {
                header.buttonImageView.image = UIImage(named: "arrow_up")
            } else {
                header.buttonImageView.image = UIImage(named: "arrow_down")
            }
        case 4:
            header.button.tag = 4
            if showMore4 {
                header.buttonImageView.image = UIImage(named: "arrow_up")
            } else {
                header.buttonImageView.image = UIImage(named: "arrow_down")
            }
        default:
            header.button.tag = 5
            if showMore5 {
                header.buttonImageView.image = UIImage(named: "arrow_up")
            } else {
                header.buttonImageView.image = UIImage(named: "arrow_down")
            }
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(userController.currentDataCategory?.name == "Sports"){
            return 44
        }
        switch indexPath.section {
        case 0:
            return 58
        case 2:
            return 76
        default:
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "musicCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! MusicCell
        if(userController.currentDataCategory?.name == "Sports" ) {
            cell.timeLabelConstraint.constant = 0
            cell.artistLabelConstraint.constant = 0
            let data = userController.currentDataCategory?.subCategories?[indexPath.section].data[indexPath.row] as! MusicData
            cell.titleLabel.text = data.artist
            cell.artistAlbumLabel.text = ""
            cell.timeLabel.text = ""
            cell.selectionStyle = .none
        } else {
            switch indexPath.section {
            case 0:
                cell.timeLabelConstraint.constant = 0
                cell.artistLabelConstraint.constant = 22
                let data = userController.currentDataCategory?.subCategories?[indexPath.section].data[indexPath.row] as! MusicData
                cell.titleLabel.text = data.song
                cell.artistAlbumLabel.text = "\(data.artist) - \(data.album!)"
                cell.timeLabel.text = ""
                cell.selectionStyle = .none
            case 2:
                cell.timeLabelConstraint.constant = 39
                cell.artistLabelConstraint.constant = 22
                let data = userController.currentDataCategory?.subCategories?[indexPath.section].data[indexPath.row] as! MusicData
                cell.titleLabel.text = data.song
                cell.artistAlbumLabel.text = "\(data.artist) - \(data.album!)"
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = TimeZone(abbreviation: "MST")
                dateFormatter.dateFormat = "EEE, dd MMM yyyy - h:mm a"
                let dateString = dateFormatter.string(from: data.time!)
                cell.timeLabel.text = dateString
                cell.selectionStyle = .none
            default:
                cell.timeLabelConstraint.constant = 0
                cell.artistLabelConstraint.constant = 0
                let data = userController.currentDataCategory?.subCategories?[indexPath.section].data[indexPath.row] as! MusicData
                cell.titleLabel.text = data.artist
                cell.artistAlbumLabel.text = ""
                cell.timeLabel.text = ""
                cell.selectionStyle = .none
            }
        }
                cell.selectionStyle = .none
        cell.timeLabel.frame = CGRect(x: cell.timeLabel.frame.origin.x, y: cell.timeLabel.frame.origin.y, width: self.view.frame.width - 25, height: cell.timeLabel.frame.height)
        cell.artistAlbumLabel.frame = CGRect(x: cell.artistAlbumLabel.frame.origin.x, y: cell.artistAlbumLabel.frame.origin.y, width: self.view.frame.width - 25, height: cell.artistAlbumLabel.frame.height)
        cell.titleLabel.frame = CGRect(x: cell.titleLabel.frame.origin.x, y: cell.titleLabel.frame.origin.y, width: self.view.frame.width - 25, height: cell.titleLabel.frame.height)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let subCategories = userController.currentDataCategory?.subCategories
        if subCategories != nil {
            return (subCategories?.count)!
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = userController.currentDataCategory?.subCategories?[section].data {
            switch section {
            case 0:
                let dataCount = data.count
                if showMore0 {
                    return dataCount
                } else {
                    var count = 5
                    if dataCount < count {
                        count = dataCount
                    }
                    return count
                }
            case 1:
                let dataCount = data.count
                if showMore1 {
                    return dataCount
                } else {
                    var count = 5
                    if dataCount < count {
                        count = dataCount
                    }
                    return count
                }
            case 2:
                let dataCount = data.count
                if showMore2 {
                    return dataCount
                } else {
                    var count = 5
                    if dataCount < count {
                        count = dataCount
                    }
                    return count
                }
            case 3:
                let dataCount = data.count
                if showMore3 {
                    return dataCount
                } else {
                    var count = 5
                    if dataCount < count {
                        count = dataCount
                    }
                    return count
                }
            case 4:
                let dataCount = data.count
                if showMore4 {
                    return dataCount
                } else {
                    var count = 5
                    if dataCount < count {
                        count = dataCount
                    }
                    return count
                }
            default:
                let dataCount = data.count
                if showMore5 {
                    return dataCount
                } else {
                    var count = 5
                    if dataCount < count {
                        count = dataCount
                    }
                    return count
                }
            }
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if !((userController.currentDataCategory?.subCategories?[indexPath.row].subCategories?.isEmpty)!) {
//            let parentCategory = userController.currentDataCategory
//            userController.currentDataCategory = userController.currentDataCategory?.subCategories?[indexPath.row]
//            userController.currentDataCategory?.parentCategory = parentCategory
//            let dataCategoryVC = DataCategoryVC()
//            self.navigationController?.pushViewController(dataCategoryVC, animated: true)
//            tableView.deselectRow(at: indexPath, animated: true)
//        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .default, title: "Remove") { (action, indexPath) in
            let userController = UserController.sharedInstance
            userController.currentDataCategory?.subCategories?[indexPath.section].data.remove(at: indexPath.row)
            UIView.transition(with: self.view, duration: 0.15, options: [.curveEaseInOut, .transitionCrossDissolve], animations: {
                self.tableView.reloadData()
            }, completion: nil)
        }
        deleteButton.backgroundColor = UIColor(red: 226/255, green: 96/255, blue: 86/255, alpha: 1)
        return [deleteButton]
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //we need this here even though it isn't doing anything
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
                            print("not all music talbes updated")
                        }
                        self.tableView.reloadData()
                        self.showingLoadAnimation = false
                        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                    }
                }, completion: nil)
            }
        }
    }
    
    func showMoreLessButtonPressed(_ sender: UIButton) {
        //this stuff keeps the dropdown from jumping when it pulls back up
        var offset = self.tableView.contentOffset
        var indexPath = tableView.indexPathForRow(at: offset)
        if indexPath == nil {
            print(offset)
            //there was a crazy crash here so we have to add section header height (40)
            offset = CGPoint(x: 0, y: tableView.contentOffset.y + 40)
            print(offset)
            indexPath = tableView.indexPathForRow(at: offset)
        }
        switch sender.tag {
        case 0:
            if showMore0 {
                if (self.tableView.indexPathForRow(at: offset)?.section)! >= sender.tag {
                    self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: sender.tag), at: .top, animated: false)
                }
            }
            showMore0 = !showMore0
        case 1:
            if showMore1 {
                if (self.tableView.indexPathForRow(at: offset)?.section)! >= sender.tag {
                    self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: sender.tag), at: .top, animated: false)
                }
            }
            showMore1 = !showMore1
        case 2:
            if showMore2 {
                if (self.tableView.indexPathForRow(at: offset)?.section)! >= sender.tag {
                    self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: sender.tag), at: .top, animated: false)
                }
            }
            showMore2 = !showMore2
        case 3:
            if showMore3 {
                if (self.tableView.indexPathForRow(at: offset)?.section)! >= sender.tag {
                    self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: sender.tag), at: .top, animated: false)
                }
            }
            showMore3 = !showMore3
        case 4:
            if showMore4 {
                if (self.tableView.indexPathForRow(at: offset)?.section)! >= sender.tag {
                    self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: sender.tag), at: .top, animated: false)
                }
            }
            showMore4 = !showMore4
        default:
            if showMore5 {
                if (self.tableView.indexPathForRow(at: offset)?.section)! >= sender.tag {
                    self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: sender.tag), at: .top, animated: false)
                }
            }
            showMore5 = !showMore5
        }
        self.tableView.reloadData()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        userController.currentDataCategory = userController.currentDataCategory?.parentCategory
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
