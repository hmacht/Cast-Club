//
//  LoadingView.swift
//  Cast Club
//
//  Created by Toby Kreiman on 6/18/19.
//  Copyright © 2019 Henry Macht. All rights reserved.
//

import UIKit

class LoadingView: UIView {

    let shapeLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let trackLayer = CAShapeLayer()
        
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.width/2, y: frame.height/2), radius: frame.width/2, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        trackLayer.path = circularPath.cgPath
        
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 3
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        //trackLayer.position = self.center
        
        self.layer.addSublayer(trackLayer)
        
        let path2 = UIBezierPath(arcCenter: CGPoint(x: frame.width/2, y: frame.height/2), radius: frame.width/2, startAngle: -.pi/2, endAngle: 3 * .pi/2, clockwise: true)
        
        shapeLayer.path = path2.cgPath
        
        shapeLayer.strokeColor = UIColor(red: 0, green: 123/255, blue: 254/255, alpha: 1).cgColor
        shapeLayer.lineWidth = 5
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        //shapeLayer.position = self.center
        
        //shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        
        shapeLayer.strokeEnd = 0
        
        self.layer.addSublayer(shapeLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let trackLayer = CAShapeLayer()
        
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 10, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer.path = circularPath.cgPath
        
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 1
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        trackLayer.position = self.center
        
        self.layer.addSublayer(trackLayer)
        
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.strokeColor = UIColor(red: 0, green: 123/255, blue: 254/255, alpha: 1).cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.position = self.center
        
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        
        shapeLayer.strokeEnd = 0.5
        
        self.layer.addSublayer(shapeLayer)
    }
    
    func animateCircle(percent: CGFloat) {
        self.shapeLayer.strokeEnd = percent
        
        if percent == 1.0 {
            let checkImage = UIImageView(image: UIImage(named: "Group 463"))
            checkImage.frame = self.frame
            self.superview?.addSubview(checkImage)
            self.removeFromSuperview()
        }
    }
}
