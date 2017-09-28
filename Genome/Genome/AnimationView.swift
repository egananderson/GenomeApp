//
//  AnimationView.swift
//  Genome
//
//  Created by Egan Anderson on 4/20/17.
//  Copyright © 2017 Egan Anderson. All rights reserved.
//

import UIKit

class AnimationView: UIView {
    var outline1: UIImageView!
    var outline2: UIImageView!
    var outline3: UIImageView!
    var outline4: UIImageView!
    
    var container1: UIView!
    var container2: UIView!
    var container3: UIView!
    var container4: UIView!
    
    var background1: UIImageView!
    var background2: UIImageView!
    var background3: UIImageView!
    var background4: UIImageView!

    override func awakeFromNib() {
        self.backgroundColor = UIColor.clear
        
        let offset: CGFloat = self.frame.height/2.5
        let distance = self.frame.height/1.72
        
        let outlineImage = UIImage(named: "DNA_Outline_3")?.imageWithColor(color: UIColor(red: 40/255, green: 47/255, blue: 62/255, alpha: 1))
        
        container1 = UIView(frame: CGRect(x: 0-offset, y: 0, width: self.frame.height*0.457, height: self.frame.height))
        background1 = UIImageView(frame: CGRect(x: container1.frame.height*0.05, y: container1.frame.height*0.02, width: container1.frame.width-container1.frame.height*0.1, height: container1.frame.height*0.96))
        background1.backgroundColor = UIColor.orange
        outline1 = UIImageView(image: outlineImage)
        outline1.frame = container1.bounds
        outline1.contentMode = .scaleAspectFit
        container1.addSubview(background1)
        container1.addSubview(outline1)
        container1.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/4))
        self.addSubview(container1)
        
        container2 = UIView(frame: CGRect(x: distance - offset, y: 0, width: self.frame.height*0.457, height: self.frame.height))
        background2 = UIImageView(frame: CGRect(x: container2.frame.height*0.05, y: container2.frame.height*0.02, width: container2.frame.width-container2.frame.height*0.1, height: container2.frame.height*0.96))
        background2.backgroundColor = UIColor.orange
        outline2 = UIImageView(image: outlineImage)
        outline2.frame = container2.bounds
        outline2.contentMode = .scaleAspectFit
        container2.addSubview(background2)
        container2.addSubview(outline2)
        container2.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/4))
        self.addSubview(container2)
        
        container3 = UIView(frame: CGRect(x: 2*distance - offset, y: 0, width: self.frame.height*0.457, height: self.frame.height))
        background3 = UIImageView(frame: CGRect(x: container3.frame.height*0.05, y: container3.frame.height*0.02, width: container3.frame.width-container3.frame.height*0.1, height: container3.frame.height*0.96))
        background3.backgroundColor = UIColor.orange
        outline3 = UIImageView(image: outlineImage)
        outline3.frame = container3.bounds
        outline3.contentMode = .scaleAspectFit
        container3.addSubview(background3)
        container3.addSubview(outline3)
        container3.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/4))
        self.addSubview(container3)

        container4 = UIView(frame: CGRect(x: 3*distance - offset, y: 0, width: self.frame.height*0.457, height: self.frame.height))
        background4 = UIImageView(frame: CGRect(x: container4.frame.height*0.05, y: container4.frame.height*0.02, width: container4.frame.width-container4.frame.height*0.1, height: container4.frame.height*0.96))
        background4.backgroundColor = UIColor.orange
        outline4 = UIImageView(image: outlineImage)
        outline4.frame = container4.bounds
        outline4.contentMode = .scaleAspectFit
        container4.addSubview(background4)
        container4.addSubview(outline4)
        container4.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/4))
        self.addSubview(container4)
    }
    
    func startAnimating(color: UIColor) {
        let animationController = AnimationController()
        animationController.startAnimation(animationView: self, color: color)
    }
    
}

extension UIImage {
    func imageWithColor(color: UIColor) -> UIImage? {
        var image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
