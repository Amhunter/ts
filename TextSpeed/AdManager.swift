//
//  Banner.swift
//  TextSpeed
//
//  Created by Grisha on 21/06/2016.
//  Copyright © 2016 Grisha. All rights reserved.
//

import UIKit

class Registration {
    var appDelegate:AppDelegate!
    static var sharedInstance = Registration()
    func showAds(viewController:UIViewController, view:UIView?) {
        
        let bannerView:UIView = view ?? viewController.view
        
        //Admob
        appDelegate.adMobBanner.rootViewController = viewController
        appDelegate.adMobBanner.delegate = appDelegate
        let request = GADRequest()
        appDelegate.adMobBanner.adUnitID = "ca-app-pub-2682126928165727/9577327896"
        appDelegate.adMobBanner.loadRequest(request)
        appDelegate.adMobBanner.translatesAutoresizingMaskIntoConstraints = false
        bannerView.addSubview(appDelegate.adMobBanner)
        var myConstraint = NSLayoutConstraint(item: appDelegate.adMobBanner, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: bannerView, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0)
        bannerView.addConstraint(myConstraint)
        myConstraint = NSLayoutConstraint(item: appDelegate.adMobBanner, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: bannerView, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0)
        bannerView.addConstraint(myConstraint)
        myConstraint = NSLayoutConstraint(item: appDelegate.adMobBanner, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: bannerView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
        bannerView.addConstraint(myConstraint)

    }


}