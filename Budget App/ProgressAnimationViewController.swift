//
//  ProgressAnimationViewController.swift
//  Budget App
//
//  Created by Aaron Orr on 10/4/18.
//  Copyright © 2018 Icecream. All rights reserved.
//

import UIKit

class ProgressAnimationViewController: UIViewController {
    
    let shapelayer = CAShapeLayer()
    
    let percentage = CGFloat(2) / CGFloat(6)

    override func viewDidLoad() {
        super.viewDidLoad()

        let center = view.center
        
        // Create track layer
        let trackLayer = CAShapeLayer()
        
        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer.path = circularPath.cgPath
        
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 10
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = kCALineCapRound
        view.layer.addSublayer(trackLayer)
        
        
        // Draw a circle
        shapelayer.path = circularPath.cgPath
        
        shapelayer.strokeColor = UIColor.red.cgColor
        shapelayer.lineWidth = 10
        shapelayer.fillColor = UIColor.clear.cgColor
        shapelayer.lineCap = kCALineCapRound
        
        shapelayer.strokeEnd = percentage
        
        view.layer.addSublayer(shapelayer)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    @objc private func handleTap() {
        print("Attempting to animate stroke")
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 1
        basicAnimation.duration = 2
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapelayer.add(basicAnimation, forKey: "urSoBasic")
        
    }
    
}
