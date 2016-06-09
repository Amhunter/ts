//
//  Timer.swift
//  KeySpeed
//
//  Created by Grisha on 18/05/2016.
//  Copyright © 2016 Grisha. All rights reserved.
//

import UIKit

protocol TimerDelegate {
    func timerWillStart(timer : Timer)
    func timerDidFire(timer : Timer)
    func timerDidPause(timer : Timer)
    func timerWillResume(timer : Timer)
    func timerDidStop(timer : Timer)
}

class Timer: NSObject {
    var timer : NSTimer!
    var interval : NSTimeInterval
    var difference : NSTimeInterval = 0.0
    var delegate : TimerDelegate?
    
    init(interval: NSTimeInterval, delegate: TimerDelegate?)
    {
        self.interval = interval
        self.delegate = delegate
    }
    
    func start(aTimer : NSTimer?)
    {
        if aTimer != nil { fire() }
        if timer == nil {
            if delegate != nil {
                delegate!.timerWillStart(self)
            }
            timer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: #selector(fire), userInfo: nil, repeats: true)
        }
    }
    
    func pause()
    {
        if timer != nil {
            difference = timer.fireDate.timeIntervalSinceDate(NSDate())
            timer.invalidate()
            timer = nil
            
            if delegate != nil {
                delegate!.timerDidPause(self)
            }
        }
    }
    
    func resume()
    {
        if timer == nil {
            
            if delegate != nil {
                delegate!.timerWillResume(self)
            }

            if difference == 0.0 {
                start(nil)
            } else {
                NSTimer.scheduledTimerWithTimeInterval(difference, target: self, selector: #selector(start(_:)), userInfo: nil, repeats: false)
                difference = 0.0
            }
        }
    }
    
    func stop()
    {
        if timer != nil {
            difference = 0.0
            timer.invalidate()
            timer = nil
            if delegate != nil {
                delegate!.timerDidStop(self)

            }
        }
    }
    
    func fire()
    {
        if delegate != nil {
            delegate!.timerDidFire(self)
        }
    }
}
