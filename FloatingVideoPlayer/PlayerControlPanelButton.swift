//
//  PlayButton.swift
//  FloatingVideoPlayer
//
//  Created by 任岐鸣 on 2016/7/31.
//  Copyright © 2016年 Ned. All rights reserved.
//

import UIKit

class PlayerControlPanelButton: UIButton {
    
    let circleBg = CAShapeLayer()
    let circle = CAShapeLayer()
    let triangle = CAShapeLayer()
    let rightPauseLine = CAShapeLayer()
    
    let duration = 0.6 * 2
    let subDuration = 0.2 * 2
    
    
    func setToPlay() {
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
            self.circle.strokeStart = 0
            self.circle.strokeEnd = 0
         }, completion: {
            Bool in
            
        })
        UIView.animate(withDuration: subDuration, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
            self.rightPauseLine.strokeStart = 0
            self.rightPauseLine.strokeEnd = 0.52
        }, completion: {
            Bool in
            UIView.animate(withDuration: self.subDuration, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
                //            self.rightPauseLine.strokeStart = 0
                self.rightPauseLine.strokeEnd = 0
                self.triangle.strokeStart = 0.3
            }, completion: {
                Bool in
                UIView.animate(withDuration: self.subDuration, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
                    //            self.rightPauseLine.strokeStart = 0
                    self.rightPauseLine.strokeEnd = 0
                    self.triangle.strokeStart = 0
                }, completion: {
                    Bool in
                    
                })
            })
        })
        
        
    }
    
    func setToPause() {
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
            self.circle.strokeStart = 0
            self.circle.strokeEnd = 1
            
        }, completion: {
            Bool in
            
        })
        UIView.animate(withDuration: subDuration, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
            self.triangle.strokeStart = 0.3 //0.65
            
            self.rightPauseLine.strokeStart = 0 //0.52
            self.rightPauseLine.strokeEnd = 0 //1
        }, completion: {
            Bool in
            UIView.animate(withDuration: self.subDuration, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
                self.triangle.strokeStart = 0.65
                
                self.rightPauseLine.strokeStart = 0 //0.52
                self.rightPauseLine.strokeEnd = 0.3 //1
            }, completion: {
                Bool in
                UIView.animate(withDuration: self.subDuration, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
                    
                    self.rightPauseLine.strokeStart = 0.52
                    self.rightPauseLine.strokeEnd = 1
                }, completion: {
                    Bool in
                    
                })
            })
        })
        
        
    }
    
    func initPlayButton() {
        let lineWidth:CGFloat = 2
        let rectLength = min(self.frame.width, self.frame.height)
        let leftUpPoint = CGPoint.init(x: getCenter().x-7, y: getCenter().y-10)
        let leftDownPoint = CGPoint.init(x: getCenter().x-7, y: getCenter().y+10)
        let rightPoint = CGPoint.init(x: getCenter().x+7, y: getCenter().y)
        
        let rightUpPoint = CGPoint.init(x: getCenter().x+7, y: getCenter().y-10)
        let rightDownPoint = CGPoint.init(x: getCenter().x+7, y: getCenter().y+10)
        let downArcCenter = CGPoint.init(x: getCenter().x, y: getCenter().y+10)
        
        
        circleBg.frame = self.bounds
        let circleBgPath = UIBezierPath.init(arcCenter: getCenter(), radius: rectLength/2, startAngle: 0, endAngle: CGFloat(2.0*M_PI), clockwise: true)
        circleBg.path = circleBgPath.cgPath
        circleBg.fillColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        circleBg.strokeColor = UIColor.lightGray.cgColor
        circleBg.lineWidth = lineWidth
        
        circle.frame = self.bounds
        let circlePath = UIBezierPath.init(arcCenter: getCenter(), radius: rectLength/2, startAngle: CGFloat(M_PI*1.5), endAngle: CGFloat(M_PI_2 * -1.0), clockwise: false)
        circlePath.lineCapStyle = .round
        circle.path = circlePath.cgPath
        circle.fillColor = UIColor.clear.cgColor
        circle.strokeColor = UIColor.white.cgColor
        circle.lineWidth = lineWidth
        
        triangle.frame = self.bounds
        let trianglePath = UIBezierPath.init()
        trianglePath.move(to: leftDownPoint)
        trianglePath.addLine(to: rightPoint)
        trianglePath.addLine(to: leftUpPoint)
        trianglePath.addLine(to: leftDownPoint)
        trianglePath.close()
        trianglePath.lineJoinStyle = .round
        trianglePath.lineCapStyle = .round
        triangle.path = trianglePath.cgPath
        triangle.strokeColor = UIColor.white.cgColor
        triangle.fillColor = UIColor.clear.cgColor
        //triangle.strokeStart = 0.3
        triangle.strokeStart = 0.65
        triangle.lineWidth = lineWidth + 1
        //        triangle.linejoinStyle
        
        rightPauseLine.frame = self.bounds
        let rightPausePath = UIBezierPath.init()
        rightPausePath.move(to: leftDownPoint)
        rightPausePath.addArc(withCenter: downArcCenter, radius: 7, startAngle: CGFloat(M_PI_2 * 2.0), endAngle: CGFloat(2.0*M_PI), clockwise: false)
        rightPausePath.move(to: rightDownPoint)
        rightPausePath.addLine(to: rightUpPoint)
        rightPausePath.lineJoinStyle = .round
        rightPauseLine.path = rightPausePath.cgPath
        rightPauseLine.strokeColor = UIColor.white.cgColor
        rightPauseLine.fillColor = UIColor.clear.cgColor
        rightPauseLine.strokeStart = 0.52
        rightPauseLine.lineWidth = lineWidth + 1
        
        layer.addSublayer(circleBg)
        layer.addSublayer(circle)
        layer.addSublayer(triangle)
        layer.addSublayer(rightPauseLine)
        
    }
    
    func initPrevButton() {
        let lineWidth:CGFloat = 2
        let rectLength = min(self.frame.width, self.frame.height)
        let leftUpPoint = CGPoint.init(x: getCenter().x-7, y: getCenter().y-11)
        let leftDownPoint = CGPoint.init(x: getCenter().x-7, y: getCenter().y+11)
        let leftPoint = CGPoint.init(x: getCenter().x-5, y: getCenter().y)
        
        let rightUpPoint = CGPoint.init(x: getCenter().x+7, y: getCenter().y-10)
        let rightDownPoint = CGPoint.init(x: getCenter().x+7, y: getCenter().y+10)
        
        
        circleBg.frame = self.bounds
        let circleBgPath = UIBezierPath.init(arcCenter: getCenter(), radius: rectLength/3, startAngle: 0, endAngle: CGFloat(2.0*M_PI), clockwise: true)
        circleBg.path = circleBgPath.cgPath
        circleBg.fillColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        circleBg.strokeColor = UIColor.clear.cgColor
        circleBg.lineWidth = lineWidth
        
        circle.frame = self.bounds
        let circlePath = UIBezierPath.init(arcCenter: getCenter(), radius: rectLength/2, startAngle: CGFloat(M_PI*1.5), endAngle: CGFloat(M_PI_2 * -1.0), clockwise: false)
        circlePath.lineCapStyle = .round
        circle.path = circlePath.cgPath
        circle.fillColor = UIColor.clear.cgColor
        circle.strokeColor = UIColor.white.cgColor
        circle.lineWidth = lineWidth
        
        triangle.frame = self.bounds
        let trianglePath = UIBezierPath.init()
        trianglePath.move(to: rightDownPoint)
        trianglePath.addLine(to: rightUpPoint)
        trianglePath.addLine(to: leftPoint)
        trianglePath.addLine(to: rightDownPoint)
        trianglePath.close()
        trianglePath.lineJoinStyle = .round
        trianglePath.lineCapStyle = .round
        triangle.path = trianglePath.cgPath
        triangle.strokeColor = UIColor.white.cgColor
        triangle.fillColor = UIColor.clear.cgColor
        triangle.lineWidth = lineWidth + 1
        
        rightPauseLine.frame = self.bounds
        let leftPath = UIBezierPath.init()
        leftPath.move(to: leftUpPoint)
        leftPath.addLine(to: leftDownPoint)
        leftPath.lineJoinStyle = .round
        rightPauseLine.path = leftPath.cgPath
        rightPauseLine.strokeColor = UIColor.white.cgColor
        rightPauseLine.fillColor = UIColor.clear.cgColor
        rightPauseLine.lineWidth = lineWidth + 1
        
        layer.addSublayer(circleBg)
        layer.addSublayer(triangle)
        layer.addSublayer(rightPauseLine)

    }
    func initNextButton() {
        let lineWidth:CGFloat = 2
        let rectLength = min(self.frame.width, self.frame.height)
        let leftUpPoint = CGPoint.init(x: getCenter().x-7, y: getCenter().y-10)
        let leftDownPoint = CGPoint.init(x: getCenter().x-7, y: getCenter().y+10)
        let rightPoint = CGPoint.init(x: getCenter().x+5, y: getCenter().y)
        
        let rightUpPoint = CGPoint.init(x: getCenter().x+7, y: getCenter().y-11)
        let rightDownPoint = CGPoint.init(x: getCenter().x+7, y: getCenter().y+11)
        
        circleBg.frame = self.bounds
        let circleBgPath = UIBezierPath.init(arcCenter: getCenter(), radius: rectLength/3, startAngle: 0, endAngle: CGFloat(2.0*M_PI), clockwise: true)
        circleBg.path = circleBgPath.cgPath
        circleBg.fillColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        circleBg.strokeColor = UIColor.clear.cgColor
        circleBg.lineWidth = lineWidth
        
        circle.frame = self.bounds
        let circlePath = UIBezierPath.init(arcCenter: getCenter(), radius: rectLength/2, startAngle: CGFloat(M_PI*1.5), endAngle: CGFloat(M_PI_2 * -1.0), clockwise: false)
        circlePath.lineCapStyle = .round
        circle.path = circlePath.cgPath
        circle.fillColor = UIColor.clear.cgColor
        circle.strokeColor = UIColor.white.cgColor
        circle.lineWidth = lineWidth
        
        triangle.frame = self.bounds
        let trianglePath = UIBezierPath.init()
        trianglePath.move(to: leftDownPoint)
        trianglePath.addLine(to: rightPoint)
        trianglePath.addLine(to: leftUpPoint)
        trianglePath.close()
        trianglePath.lineJoinStyle = .round
        trianglePath.lineCapStyle = .round
        triangle.path = trianglePath.cgPath
        triangle.strokeColor = UIColor.white.cgColor
        triangle.fillColor = UIColor.clear.cgColor
        triangle.lineWidth = lineWidth + 1
        
        rightPauseLine.frame = self.bounds
        let rightPausePath = UIBezierPath.init()
        rightPausePath.move(to: rightDownPoint)
        rightPausePath.addLine(to: rightUpPoint)
        rightPausePath.lineJoinStyle = .round
        rightPauseLine.path = rightPausePath.cgPath
        rightPauseLine.strokeColor = UIColor.white.cgColor
        rightPauseLine.fillColor = UIColor.clear.cgColor
        rightPauseLine.lineWidth = lineWidth + 1
        
        layer.addSublayer(circleBg)
        layer.addSublayer(triangle)
        layer.addSublayer(rightPauseLine)

    }
    func getCenter() -> CGPoint {
        return CGPoint.init(x: self.frame.width/2, y: self.frame.height/2)
    }
    
}
