//
//  SpeedometerView.swift
//  KeySpeed
//
//  Created by Grisha on 22/05/2016.
//  Copyright © 2016 Grisha. All rights reserved.
//

import UIKit
extension Int {
    var degreesToRadians: Double { return Double(self) * M_PI / 180 }
    var radiansToDegrees: Double { return Double(self) * 180 / M_PI }
}

extension Double {
    var degreesToRadians: Double { return self * M_PI / 180 }
    var radiansToDegrees: Double { return self * 180 / M_PI }
    
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
}

extension CGFloat {
    var doubleValue:      Double  { return Double(self) }
    var degreesToRadians: CGFloat { return CGFloat(doubleValue * M_PI / 180) }
    var radiansToDegrees: CGFloat { return CGFloat(doubleValue * 180 / M_PI) }
}

extension Float  {
    var doubleValue:      Double { return Double(self) }
    var degreesToRadians: Float  { return Float(doubleValue * M_PI / 180) }
    var radiansToDegrees: Float  { return Float(doubleValue * 180 / M_PI) }
}

class SpeedometerView: UIImageView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    let screenWidth = UIScreen.mainScreen().bounds.width
    
    var arrowImageView = UIImageView()
    var speedometerCurrentValue:CGFloat = 0
    var currentAngle:Double = 0
    var speedometerTimer:NSTimer!
    var speedometerLimitValue:Double = 600
    let negativeAngle:Double = 30
    let straightAngle:Double = 90
    var maximumAngle:Double!
    var numberOfSections:Int = 8
    var sectionAngle:Double!
    let arrowWidth:CGFloat = 2
    var offset:Double!
    
    
    let imageSize = UIImage(named: "speedometer2x")!.size
    let arrowImageSize = UIImage(named: "speedometerArrow2x")!.size

    var scale:CGFloat = 1
    init() {
        super.init(image: UIImage(named: "speedometer2x"))
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setSpeedometer() {


        

//
//        let viewHeight = self.frame.height
//        
//        self.frame.size.width = (imageWidth/imageHeight)*viewHeight
        
        self.addSubview(arrowImageView)
//        self.arrowImageView.backgroundColor = UIColor.whiteColor()
//        print(self.frame)
        maximumAngle = 180+negativeAngle+negativeAngle
        offset = -straightAngle-negativeAngle
        sectionAngle = maximumAngle/Double(numberOfSections)
        setSpeed(0)
//        self.arrowImageView.transform = CGAffineTransformMakeRotation((CGFloat(M_PI) / 180) * -90)
        self.arrowImageView.layer.anchorPoint =  CGPointMake(0.5, 1);
        self.arrowImageView.image = UIImage(named: "speedometerArrow2x")


    }
    
    func speedometerFrameWasUpdated() {
        //        self.setNeedsLayout()
        //        self.layoutIfNeeded()
        print("hey")
        let imageWidth = imageSize.width
        let imageHeight = imageSize.height

        
        scale = self.frame.width/imageWidth
        print(self.frame)
        
        let arrowProportion = arrowImageSize.height/arrowImageSize.width
        let arrowHeight = self.frame.width/2-(45*scale)
        let arrowWidth = arrowHeight/arrowProportion
        self.arrowImageView.frame.size = CGSizeMake(arrowWidth, arrowHeight)
        self.arrowImageView.center = CGPointMake(self.frame.width/2,self.frame.width/2)
//        self.arrowImageView.frame = CGRectMake(self.frame.width/2-(arrowWidth/2),self.frame.width/4-(arrowHeight/2), arrowWidth*scale, self.frame.width-(35*scale))
//        setAnchorPoint()

    }
    func setAnchorPoint(){
        let anchorPoint =  CGPointMake(0.5, 1);
        let oldOrigin = arrowImageView.frame.origin
        arrowImageView.layer.anchorPoint = anchorPoint
        let newOrigin = arrowImageView.frame.origin
        
        let transition = CGPointMake (newOrigin.x - oldOrigin.x, newOrigin.y - oldOrigin.y)
        
        arrowImageView.center = CGPointMake (arrowImageView.center.x - transition.x, arrowImageView.center.y - transition.y)
    }
    
    func startSpeedometer() {
        if (self.speedometerTimer != nil) {
            self.speedometerTimer.invalidate()
            self.speedometerTimer = nil
        }
//        self.speedometerTimer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(setSpeedometerCurrentValue), userInfo: nil, repeats: true)

    }
    
    func stopSpeedometer() {
        if (self.speedometerTimer != nil) {
            self.speedometerTimer.invalidate()
            self.speedometerTimer = nil
        }
    }

//    func setSpeedometerCurrentValue() {
//        if (self.speedometerTimer != nil) {
//            self.speedometerTimer.invalidate()
//            self.speedometerTimer = nil
//        }
////        self.speedometerCurrentValue = arc4random() % 100
//        // Generate Random value between 0 to 100. //
//        self.speedometerTimer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(setSpeedometerCurrentValue), userInfo: nil, repeats: true)
////        self.speedometerReading.text = String(format: "%.2f", self.speedometerCurrentValue)
//        // Calculate the Angle by which the needle should rotate //
////        self.calculateDeviationAngle()
//    }
//    
    
    
//    func calculateDeviationAngle() {
//        if CFloat(self.maxVal)! > 0 {
//            self.angle = ((self.speedometerCurrentValue * 237.4) / CFloat(self.maxVal)!) - 118.4
//            // 237.4 - Total angle between 0 - 100 //
//        }
//        else {
//            self.angle = 0
//        }
//        if self.angle <= -118.4 {
//            self.angle = -118.4
//        }
//        if self.angle >= 119 {
//            self.angle = 119
//        }
//        // If Calculated angle is greater than 180 deg, to avoid the needle to rotate in reverse direction first rotate the needle 1/3 of the calculated angle and then 2/3. //
//        if abs(self.angle - self.prevAngleFactor) > 180 {
//            UIView.beginAnimations(nil, context: nil)
//            UIView.setAnimationDuration(0.5)
//            self.rotateIt(self.angle / 3)
//            UIView.commitAnimations()
//            UIView.beginAnimations(nil, context: nil)
//            UIView.setAnimationDuration(0.5)
//            self.rotateIt((self.angle * 2) / 3)
//            UIView.commitAnimations()
//        }
//        self.prevAngleFactor = self.angle
//        // Rotate Needle //
//        self.rotateArrowToCurrentAngle()
//    }
//  
    func setSpeed(speed:Double) {

        if launchingSpeedometer {
            return
        }
        let angle:Double = convertSpeedToAngle(speed)
        
        self.rotateArrow(angle)
    }

    func convertSpeedToAngle(speed:Double) -> Double{
        
        var targetAngle:Double = 0
        switch speed {
        case 0...10:
            targetAngle = (speed-0/10-0)*sectionAngle
//            print("0-10 is \(speed)")
        case 10...25:
            let offst = sectionAngle*1
            targetAngle = (speed-10)/(25-10)*sectionAngle
            targetAngle += offst
//            print("10-25 is \(speed)")
        case 25...50:
            let offst = sectionAngle*2
            targetAngle = (speed-25)/(50-25)*sectionAngle
            targetAngle += offst
//            print("25-50 is \(speed)")
        case 50...100:
            let offst = sectionAngle*3
            targetAngle = (speed-50)/(100-50)*sectionAngle
            targetAngle += offst
//            print("50-100 is \(speed)")
        case 100...200:
            let offst = sectionAngle*4
            targetAngle = (speed-100)/(200-100)*sectionAngle
            targetAngle += offst
//            print("100-200 is \(speed)")
        case 200...300:
            let offst = sectionAngle*5
            targetAngle = (speed-200)/(300-200)*sectionAngle
            targetAngle += offst
//            print("200-300 is \(speed)")
        case 300...450:
            let offst = sectionAngle*6
            targetAngle = (speed-300)/(450-300)*sectionAngle
            targetAngle += offst
//            print("300-450 is \(speed)")
        case 450...600:
            let offst = sectionAngle*7
            targetAngle = (speed-450)/(600-450)*sectionAngle
            targetAngle += offst
//            print("450-600 is \(speed)")
        default:
            print("this is MADNESS")
        }
        
        
//        print("Target Angle: \(targetAngle)")
        return targetAngle+offset

    }
    
    func pauseSpeedometer() {
//        self.arrowImageView.layer.removeAllAnimations() // <<====  Solution
//        self.arrowImageView.transform = CGAffineTransformMakeRotation(CGFloat(currentAngle).degreesToRadians)
    }
    
    func rotateArrow(angle: Double) {
        self.arrowImageView.layer.removeAllAnimations() // <<====  Solution

        let spinAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        spinAnimation.fromValue = self.currentAngle.degreesToRadians
        spinAnimation.toValue = angle.degreesToRadians
        spinAnimation.duration = 0.1
        spinAnimation.cumulative = true
        spinAnimation.additive = true
        spinAnimation.removedOnCompletion = false
        spinAnimation.fillMode = kCAFillModeForwards
        self.arrowImageView.layer.addAnimation(spinAnimation, forKey: "spinAnimation")
        self.currentAngle = angle

//        let decspinAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
//        decspinAnimation.fromValue = angle.degreesToRadians
//        decspinAnimation.toValue = convertSpeedToAngle(0).degreesToRadians
//        decspinAnimation.duration = 4
//        decspinAnimation.cumulative = true
//        decspinAnimation.additive = true
//        decspinAnimation.removedOnCompletion = false
//        decspinAnimation.fillMode = kCAFillModeForwards
//        self.arrowImageView.layer.addAnimation(spinAnimation, forKey: "spinAnimation")
        
        
////        self.arrowImageView.layer.removeAllAnimations() // <<====  Solution
//        
////        
////        let anim = CABasicAnimation(keyPath: "transform.rotation")
////        anim.fromValue = self.angle.degreesToRadians
////        anim.toValue = angle.degreesToRadians
////        anim.additive = true
////        anim.duration = 0.1
////        
////        arrowImageView.layer.addAnimation(anim, forKey: "rotate")
////        arrowImageView.transform = CGAffineTransformMakeRotation(-self.angle.degreesToRadians)
//        let previousAngle = self.angle
//        self.angle = angle
//        let difference = angle-previousAngle
//        print("___")
//        print("previousAngle: \(previousAngle)")
//        print("newAngle: \(angle)")
//        print("difference: \(difference)")
//
//        UIView.animateWithDuration(0.1, delay: 0.00, options: [], animations: {
//            if difference > 180 {
//                self.arrowImageView.transform = CGAffineTransformMakeRotation(CGFloat(difference-181).degreesToRadians)
//            } else {
//                self.arrowImageView.transform = CGAffineTransformMakeRotation(angle.degreesToRadians)
//
//            }
//        }) { (finished:Bool) in
////            if difference > 180 {
////                self.arrowImageView.transform = CGAffineTransformMakeRotation(angle.degreesToRadians)
////            }
//        }
        
    }
    var launchingSpeedometer = false
    func animateStarting() {
        launchingSpeedometer = true

        CATransaction.begin()
        CATransaction.setCompletionBlock({
            self.launchingSpeedometer = false
        })

        
        let spinAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        spinAnimation.fromValue = self.currentAngle.degreesToRadians
        let angle = convertSpeedToAngle(speedometerLimitValue)
        spinAnimation.toValue = angle.degreesToRadians
        spinAnimation.duration = 1.5
        spinAnimation.cumulative = true
        spinAnimation.additive = true
        spinAnimation.removedOnCompletion = false
        spinAnimation.fillMode = kCAFillModeForwards
        self.arrowImageView.layer.addAnimation(spinAnimation, forKey: "spinAnimation")
        self.currentAngle = angle
        CATransaction.commit()
    }
    
    func rotateArrowToCurrentAngle() {
        
        UIView.animateWithDuration(0.5, delay: 0.00, options: [], animations: {
            self.arrowImageView.transform = CGAffineTransformMakeRotation(CGFloat(((M_PI) / 180) * self.currentAngle))
            
        }) { (finished:Bool) in
            
        }
        
    }




}
