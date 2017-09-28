//
//  AnimationController.swift
//  Genome
//
//  Created by Egan Anderson on 4/20/17.
//  Copyright © 2017 Egan Anderson. All rights reserved.
//

import Foundation

class AnimationController: NSObject {
    let time = 2.0
    var distance: Double = 1.0
    
    override init() {}

    func startAnimation(animationView: AnimationView, color: UIColor) {
        distance = Double(animationView.container3.center.x - animationView.container2.center.x)
        
        animateStrand(strand: 1, color: color, container: animationView.container1, background: animationView.background1, outline: animationView.outline1)
        
        animateStrand(strand: 2, color: color, container: animationView.container2, background: animationView.background2, outline: animationView.outline2)
        
        animateStrand(strand: 3, color: color, container: animationView.container3, background: animationView.background3, outline: animationView.outline3)
        
        animateStrand(strand: 4, color: color, container: animationView.container4, background: animationView.background4, outline: animationView.outline4)
    }
    
    func animateStrand(strand: Int, color: UIColor, container: UIView, background: UIImageView, outline: UIImageView) {
        
        let outlineImage = UIImage(named: "DNA_Outline_3")?.imageWithColor(color: color)
        outline.image = outlineImage
        outline.contentMode = .scaleToFill
        
        switch strand {
        case 1:
            animateStrand1(container: container, background: background)
        case 2:
            animateStrand2(container: container, background: background)
        case 3:
            animateStrand3(container: container, background: background)
        default:
            animateStrand4(container: container, background: background)
        }
    }
    

    func animateStrand1(container: UIView, background: UIImageView) {

        let yFactor: CGFloat = 3.3
        
        let stretchY: CAKeyframeAnimation = CAKeyframeAnimation()
        stretchY.keyPath = "transform.scale.y"
        stretchY.values = [0.01, 1]
        stretchY.keyTimes = [0,1]
        stretchY.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        stretchY.autoreverses = false
        stretchY.duration = time/4
        stretchY.repeatCount = Float.infinity
        container.layer.add(stretchY, forKey: "stretchY")
        
        let stretchX: CAKeyframeAnimation = CAKeyframeAnimation()
        stretchX.keyPath = "transform.scale.x"
        stretchX.values = [0.2, 1]
        stretchX.keyTimes = [0,1]
        stretchX.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        stretchX.autoreverses = false
        stretchX.duration = time/4
        stretchX.repeatCount = Float.infinity
        container.layer.add(stretchX, forKey: "stretchX")
        
        let slideX: CAKeyframeAnimation = CAKeyframeAnimation()
        slideX.keyPath = "transform.translation.x"
        slideX.values = [0+container.frame.height/yFactor*1.5, distance]
        slideX.keyTimes = [0,1]
        slideX.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        slideX.autoreverses = false
        slideX.duration = time/4
        slideX.repeatCount = Float.infinity
        container.layer.add(slideX, forKey: "slideX")
        
        let slideY: CAKeyframeAnimation = CAKeyframeAnimation()
        slideY.keyPath = "transform.translation.y"
        slideY.values = [-container.frame.height/yFactor, 0]
        slideY.keyTimes = [0,1]
        slideY.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        slideY.autoreverses = false
        slideY.duration = time/4
        slideY.repeatCount = Float.infinity
        container.layer.add(slideY, forKey: "slideY")
        
        let changeColor = CAKeyframeAnimation()
        changeColor.keyPath = "backgroundColor"
        changeColor.values = [UIColor(red: 109/255, green: 223/255, blue: 158/255, alpha: 1).cgColor, UIColor(red: 103/255, green: 217/255, blue: 178/255, alpha: 1).cgColor]
        changeColor.keyTimes = [0, 1]
        changeColor.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        changeColor.autoreverses = false
        changeColor.duration = time/4
        changeColor.repeatCount = Float.infinity
        background.layer.add(changeColor, forKey: "changeColor")
    }
    
    func animateStrand2(container: UIView, background: UIImageView) {
        
        let slideX: CAKeyframeAnimation = CAKeyframeAnimation()
        slideX.keyPath = "transform.translation.x"
        slideX.values = [0, distance]
        slideX.keyTimes = [0,1]
        slideX.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        slideX.autoreverses = false
        slideX.duration = time/4
        slideX.repeatCount = Float.infinity
        container.layer.add(slideX, forKey: "slideX")
        
        let changeColor = CAKeyframeAnimation()
        changeColor.keyPath = "backgroundColor"
        changeColor.values = [UIColor(red: 103/255, green: 217/255, blue: 178/255, alpha: 1).cgColor, UIColor(red: 98/255, green: 210/255, blue: 198/255, alpha: 1).cgColor]
        changeColor.keyTimes = [0, 1]
        changeColor.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        changeColor.autoreverses = false
        changeColor.duration = time/4
        changeColor.repeatCount = Float.infinity
        background.layer.add(changeColor, forKey: "changeColor")
    }
    
    func animateStrand3(container: UIView, background: UIImageView) {
        
        let slideX: CAKeyframeAnimation = CAKeyframeAnimation()
        slideX.keyPath = "transform.translation.x"
        slideX.values = [0, distance]
        slideX.keyTimes = [0,1]
        slideX.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        slideX.autoreverses = false
        slideX.duration = time/4
        slideX.repeatCount = Float.infinity
        container.layer.add(slideX, forKey: "slideX")
        
        let changeColor = CAKeyframeAnimation()
        changeColor.keyPath = "backgroundColor"
        changeColor.values = [UIColor(red: 98/255, green: 210/255, blue: 198/255, alpha: 1).cgColor, UIColor(red: 92/255, green: 204/255, blue: 218/255, alpha: 1).cgColor]
        changeColor.keyTimes = [0, 1]
        changeColor.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        changeColor.autoreverses = false
        changeColor.duration = time/4
        changeColor.repeatCount = Float.infinity
        background.layer.add(changeColor, forKey: "changeColor")
    }
    
    func animateStrand4(container: UIView, background: UIImageView) {
        
        let yFactor: CGFloat = 3.3
        
        let stretchY: CAKeyframeAnimation = CAKeyframeAnimation()
        stretchY.keyPath = "transform.scale.y"
        stretchY.values = [1, 0.01]
        stretchY.keyTimes = [0,1]
        stretchY.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        stretchY.autoreverses = false
        stretchY.duration = time/4
        stretchY.repeatCount = Float.infinity
        container.layer.add(stretchY, forKey: "stretchY")
        
        let stretchX: CAKeyframeAnimation = CAKeyframeAnimation()
        stretchX.keyPath = "transform.scale.x"
        stretchX.values = [1, 0.2]
        stretchX.keyTimes = [0,1]
        stretchX.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        stretchX.autoreverses = false
        stretchX.duration = time/4
        stretchX.repeatCount = Float.infinity
        container.layer.add(stretchX, forKey: "stretchX")
        
        let slideX: CAKeyframeAnimation = CAKeyframeAnimation()
        slideX.keyPath = "transform.translation.x"
        slideX.values = [0, distance-Double(background.frame.height/yFactor)*1.5]
        slideX.keyTimes = [0,1]
        slideX.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        slideX.autoreverses = false
        slideX.duration = time/4
        slideX.repeatCount = Float.infinity
        container.layer.add(slideX, forKey: "slideX")
        
        let slideY: CAKeyframeAnimation = CAKeyframeAnimation()
        slideY.keyPath = "transform.translation.y"
        slideY.values = [0, Double(background.frame.height/yFactor)]
        slideY.keyTimes = [0,1]
        slideY.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        slideY.autoreverses = false
        slideY.duration = time/4
        slideY.repeatCount = Float.infinity
        container.layer.add(slideY, forKey: "slideY")
        
        let changeColor = CAKeyframeAnimation()
        changeColor.keyPath = "backgroundColor"
        changeColor.values = [UIColor(red: 92/255, green: 204/255, blue: 218/255, alpha: 1).cgColor, UIColor(red: 86/255, green: 197/255, blue: 238/255, alpha: 1).cgColor]
        changeColor.keyTimes = [0, 1]
        changeColor.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        changeColor.autoreverses = false
        changeColor.duration = time/4
        changeColor.repeatCount = Float.infinity
        background.layer.add(changeColor, forKey: "changeColor")
    }
}



