//
//  spdmtr.h
//  KeySpeed
//
//  Created by Grisha on 23/05/2016.
//  Copyright © 2016 Grisha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpeedometerDemoViewController : UIViewController {
    UIImageView *needleImageView;
    float speedometerCurrentValue;
    float prevAngleFactor;
    float angle;
    NSTimer *speedometer_Timer;
    UILabel *speedometerReading;
    NSString *maxVal;
    
}
@property(nonatomic,retain) UIImageView *needleImageView;
@property(nonatomic,assign) float speedometerCurrentValue;
@property(nonatomic,assign) float prevAngleFactor;
@property(nonatomic,assign) float angle;
@property(nonatomic,retain) NSTimer *speedometer_Timer;
@property(nonatomic,retain) UILabel *speedometerReading;
@property(nonatomic,retain) NSString *maxVal;

-(void) addMeterViewContents;
-(void) rotateIt:(float)angl;
-(void) rotateNeedle;
-(void) setSpeedometerCurrentValue;
-(void) calculateDeviationAngle;

@end
