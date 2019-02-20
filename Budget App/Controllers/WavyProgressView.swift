//
//  WavyProgressView.swift
//  Budget App
//
//  Created by Aaron Orr on 10/11/18.
//  Copyright © 2018 Icecream. All rights reserved.
//

import UIKit

class WavyProgressView: UIView {

    fileprivate var progressLayer = CAShapeLayer()
    fileprivate var trackLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createWavyPath()
        print("hello1")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createWavyPath()
        print(self.frame.width)
        
    }
    
    /*override func draw(_ rect: CGRect) {
     createWavyPath()
     }*/
    
    var progressColor = UIColor.red {
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
        }
    }
    
    var trackColor = UIColor.lightGray {
        didSet {
            trackLayer.strokeColor = trackColor.cgColor
        }
    }
    
   
    fileprivate func createWavyPath() {
        
        let wavyLine = UIBezierPath()
       
        let x1:CGFloat = bounds.width / 7
        let x2:CGFloat = bounds.width / 7
        let x3:CGFloat = bounds.width / 7
        let y1:CGFloat = 0
        let y2:CGFloat = 20
        
        let n1:CGFloat = 30  //30
        let n2:CGFloat = 20  //20
        
        wavyLine.move(to: CGPoint(x: 0, y: y2))
        wavyLine.addCurve(to: CGPoint(x: x1 * 1, y: y1), controlPoint1: CGPoint(x: (x2 * 1) - n1, y: y2), controlPoint2: CGPoint(x: (x3 * 1) - n2, y: y1))
        wavyLine.addCurve(to: CGPoint(x: x1 * 2, y: y2), controlPoint1: CGPoint(x: (x2 * 2) - n1, y: y1), controlPoint2: CGPoint(x: (x3 * 2) - n2, y: y2))
        wavyLine.addCurve(to: CGPoint(x: x1 * 3, y: y1), controlPoint1: CGPoint(x: (x2 * 3) - n1, y: y2), controlPoint2: CGPoint(x: (x3 * 3) - n2, y: y1))
        wavyLine.addCurve(to: CGPoint(x: x1 * 4, y: y2), controlPoint1: CGPoint(x: (x2 * 4) - n1, y: y1), controlPoint2: CGPoint(x: (x3 * 4) - n2, y: y2))
        wavyLine.addCurve(to: CGPoint(x: x1 * 5, y: y1), controlPoint1: CGPoint(x: (x2 * 5) - n1, y: y2), controlPoint2: CGPoint(x: (x3 * 5) - n2, y: y1))
        wavyLine.addCurve(to: CGPoint(x: x1 * 6, y: y2), controlPoint1: CGPoint(x: (x2 * 6) - n1, y: y1), controlPoint2: CGPoint(x: (x3 * 6) - n2, y: y2))
        wavyLine.addCurve(to: CGPoint(x: x1 * 7, y: y1), controlPoint1: CGPoint(x: (x2 * 7) - n1, y: y2), controlPoint2: CGPoint(x: (x3 * 7) - n2, y: y1))
        
        
        trackLayer.path = wavyLine.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.lineWidth = 5.0
        trackLayer.strokeEnd = 1.0
        layer.addSublayer(trackLayer)
        
        progressLayer.path = wavyLine.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.lineWidth = 5.0
        progressLayer.strokeEnd = 0.0
        layer.addSublayer(progressLayer)
        
    }
    
    func setProgressWithAnimation(duration: TimeInterval, value: Float) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = value
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        progressLayer.strokeEnd = CGFloat(value)
        progressLayer.add(animation, forKey: "animateprogress")
        progressLayer.lineCap = kCALineCapRound
        trackLayer.lineCap = kCALineCapRound
    }

}
