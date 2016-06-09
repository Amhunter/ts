//
//  MainMenuViewController.swift
//  KeySpeed
//
//  Created by Grisha on 19/05/2016.
//  Copyright © 2016 Grisha. All rights reserved.
//

import UIKit
import GameKit
import AVFoundation

class MainMenuViewController: UIViewController,GameViewControllerDelegate,GKGameCenterControllerDelegate {
    
    let screenHeight = UIScreen.mainScreen().bounds.height
    let screenWidth = UIScreen.mainScreen().bounds.width
    
    var backgroundImageView = UIImageView()
    var logoImageView = UIImageView()
    var menuBackgroundView = UIView()
    
    var recordButton = ShrinkButton()
    var practiceButton = ShrinkButton()
    var soundOnOffButton = ExpandButton()
    var listButton = ExpandButton()
    let initiallySoundOn = true
    
    var backgroundMusicPlayer:AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        setSubviews()
        customizeViews()
        animateLogo()
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(animateLogo),
            name: UIApplicationWillEnterForegroundNotification,
            object: UIApplication.sharedApplication())
        // Do any additional setup after loading the view.
        
        
        // Sounds
        soundOnOffButton.selected = GameManager.isSoundOn()

        
        let backgroundMusicURL = NSBundle.mainBundle().URLForResource("background-main", withExtension: "wav")
        do {
            try backgroundMusicPlayer = AVAudioPlayer(contentsOfURL: backgroundMusicURL!)
            backgroundMusicPlayer.numberOfLoops = -1
            
            let volume:Float = GameManager.isSoundOn() ? 1 : 0
            backgroundMusicPlayer.volume = volume
        } catch let error {
            print(error)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        backgroundMusicPlayer.play()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        backgroundMusicPlayer.pause()
    }
    
    func setSubviews() {
        
        self.logoImageView.image = UIImage(named: "mainMenuLogo")
        
        self.view.addSubview(backgroundImageView)
        self.backgroundImageView.frame.size = self.view.frame.size
        

        if UIDevice().userInterfaceIdiom == .Phone {
            switch UIScreen.mainScreen().nativeBounds.height {
            case 480:
                print("iPhone Classic")
            case 960:
                print("iPhone 4 or 4S")
            case 1136:
                backgroundImageView.image = UIImage(named: "background568")
                print("iPhone 5 or 5S or 5C")
            case 1334:
                backgroundImageView.image = UIImage(named: "background667")
                print("iPhone 6 or 6S")
            case 2208:
                print("iPhone 6+ or 6S+")
            default:
                print("unknown")
            }
        }
        
        
        // Subviews
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        menuBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        listButton.translatesAutoresizingMaskIntoConstraints = false
        soundOnOffButton.translatesAutoresizingMaskIntoConstraints = false

        self.backgroundImageView.addSubview(logoImageView)
        self.backgroundImageView.addSubview(menuBackgroundView)
        self.backgroundImageView.addSubview(listButton)
        self.backgroundImageView.addSubview(soundOnOffButton)
        let buttonSize = 45
        let views = [
            "logo" : logoImageView,
            "menuBackground" : menuBackgroundView,
            "soundOnOffButton" : soundOnOffButton,
            "listButton" : listButton
        ]
        
        let scale:CGFloat = screenHeight/667
        let bottomButtonSize:CGFloat = 62*scale
        
        let metrics = [
            "buttonSize": bottomButtonSize
        ]
        
        let ratioConstraint = NSLayoutConstraint(item: logoImageView, attribute: .Height, relatedBy: .Equal, toItem: logoImageView, attribute: .Width, multiplier: (logoImageView.image!.size.height / logoImageView.image!.size.width), constant: 0)

        let hConstraints0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|->=20@999-[logo]->=20@999-|", options: [], metrics: nil, views: views)
        let hConstraints1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-56@999-[menuBackground]-56@999-|", options: [], metrics: nil, views: views)
        let hConstraints2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-20@999-[soundOnOffButton]->=0@999-[listButton]-20@999-|", options: [NSLayoutFormatOptions.AlignAllCenterY], metrics: nil, views: views)

        let squareConstraint0 = NSLayoutConstraint(item: soundOnOffButton, attribute: .Height, relatedBy: .Equal, toItem: soundOnOffButton, attribute: .Width, multiplier: 1, constant: 0)
        let squareConstraint1 = NSLayoutConstraint(item: listButton, attribute: .Height, relatedBy: .Equal, toItem: listButton, attribute: .Width, multiplier: 1, constant: 0)

        
        
        let vConstraints0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-85-[logo]-70@999-[menuBackground]->=15@500-[soundOnOffButton(buttonSize@999)]-20@999-|", options: [], metrics: metrics, views: views)
        let vConstraints1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-85-[logo]-70@999-[menuBackground]->=15@500-[listButton(buttonSize@999)]-20@999-|", options: [], metrics: metrics, views: views)

        self.backgroundImageView.addConstraints(hConstraints0)
        self.backgroundImageView.addConstraints(hConstraints1)
        self.backgroundImageView.addConstraints(hConstraints2)

        self.backgroundImageView.addConstraints(vConstraints0)
        self.backgroundImageView.addConstraints(vConstraints1)
        self.backgroundImageView.addConstraint(ratioConstraint)
        self.backgroundImageView.addConstraint(squareConstraint0)
        self.backgroundImageView.addConstraint(squareConstraint1)

        self.menuBackgroundView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        
        self.backgroundImageView.userInteractionEnabled = true

        // Menu Subviews
        self.practiceButton.translatesAutoresizingMaskIntoConstraints = false
        self.recordButton.translatesAutoresizingMaskIntoConstraints = false
        self.menuBackgroundView.userInteractionEnabled = true
        self.menuBackgroundView.addSubview(practiceButton)
        self.menuBackgroundView.addSubview(recordButton)
        let menuSubviews = [
            "practiceButton" : practiceButton,
            "recordButton" : recordButton
        ]
        let mHConstraints0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-13@999-[practiceButton]-13@999-|", options: [], metrics: nil, views: menuSubviews)
        let mHConstraints1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-13@999-[recordButton]-13@999-|", options: [], metrics: nil, views: menuSubviews)
        let mVConstraints0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-23-[practiceButton(58@999)]-23@999-[recordButton(58@999)]->=23@999-|", options: [], metrics: nil, views: menuSubviews)

        self.menuBackgroundView.addConstraints(mHConstraints0)
        self.menuBackgroundView.addConstraints(mHConstraints1)
        self.menuBackgroundView.addConstraints(mVConstraints0)
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        self.initialLogoXPosition = logoImageView.frame.origin.x
    }
    
    func customizeViews() {
        
        menuBackgroundView.layer.cornerRadius = 16
        
        recordButton.backgroundColor = UIColor.blackColor()
        recordButton.setTitle("RECORD", forState: UIControlState.Normal)
        recordButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        recordButton.titleLabel!.font = UIFont(name: "Helvetica-Bold", size: 22)
        recordButton.addTarget(self, action: #selector(startRecord), forControlEvents: UIControlEvents.TouchUpInside)
        recordButton.layer.cornerRadius = 16

//        recordButton.addTarget(self, action: #selector(buttonStartTouch(_:)), forControlEvents: UIControlEvents.TouchDown)
//        recordButton.addTarget(self, action: #selector(buttonEndTouch(_:)), forControlEvents: UIControlEvents.TouchUpInside)
//        recordButton.addTarget(self, action: #selector(buttonEndTouch(_:)), forControlEvents: UIControlEvents.TouchUpOutside)

        practiceButton.backgroundColor = UIColor.blackColor()
        practiceButton.setTitle("PRACTICE", forState: UIControlState.Normal)
        practiceButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        practiceButton.titleLabel!.font = UIFont(name: "Helvetica-Bold", size: 22)
        practiceButton.layer.cornerRadius = 16
//        practiceButton.addTarget(self, action: #selector(buttonStartTouch(_:)), forControlEvents: UIControlEvents.TouchDown)
//        practiceButton.addTarget(self, action: #selector(buttonEndTouch(_:)), forControlEvents: UIControlEvents.TouchUpOutside)
//        practiceButton.addTarget(self, action: #selector(buttonEndTouch(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        soundOnOffButton.addTarget(self, action: #selector(soundOnOff(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        soundOnOffButton.selected = GameManager.isSoundOn()
        soundOnOffButton.setImage(UIImage(named: "soundon2x"), forState: UIControlState.Selected)
        soundOnOffButton.setImage(UIImage(named: "soundoff2x"), forState: UIControlState.Normal)
        
        soundOnOffButton.backgroundColor = UIColor.whiteColor()
        soundOnOffButton.layer.cornerRadius = soundOnOffButton.frame.width/2
        
        listButton.setImage(UIImage(named: "list2x"), forState: UIControlState.Normal)
        listButton.addTarget(self, action: #selector(openList), forControlEvents: UIControlEvents.TouchUpInside)
        listButton.layer.cornerRadius = listButton.frame.width/2
        listButton.backgroundColor = UIColor.whiteColor()

    }
    
    func startRecord() {
        let VC = self.storyboard!.instantiateViewControllerWithIdentifier("GameViewController") as! GameViewController
        VC.delegate = self
        self.presentViewController(VC, animated: true) {
            
            VC.gameendview.soundButton.addTarget(self, action: #selector(self.soundOnOff(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            VC.gameendview.soundButton.selected = GameManager.isSoundOn()

        }
    }
    
    func didPressReturnToHome() {
        self.dismissViewControllerAnimated(true) { 
            
        }
    }
    func soundOnOff(sender:UIButton) {
        sender.selected = !sender.selected
        soundOnOffButton.selected = sender.selected
        soundOnOffButton.selected ? GameManager.turnSoundOn() : GameManager.turnSoundOff()
        let volume:Float = soundOnOffButton.selected ? 1 : 0
        backgroundMusicPlayer.volume = volume

    }
    
    func openList() {
        showLeaderboard()
        print("List")
    }
    
    var initialLogoXPosition:CGFloat = 0
    func animateLogo() {
        
            
        UIView.animateKeyframesWithDuration(0.5, delay: 0, options: [.Autoreverse, .Repeat], animations: {
            self.logoImageView.frame.origin.x = self.initialLogoXPosition - 10
        }) {
            (finished:Bool) in
            if finished {
                self.logoImageView.frame.origin.x = self.initialLogoXPosition
            }
        }
    }
    
    
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func showLeaderboard() {
        let gcVC: GKGameCenterViewController = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = GKGameCenterViewControllerState.Leaderboards
        gcVC.leaderboardIdentifier = "LeaderboardID"
        self.presentViewController(gcVC, animated: true, completion: nil)
    }


    

}
