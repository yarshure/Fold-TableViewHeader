//
//  KKViewController.m
//  refreshDemo
//
//  Created by 孔祥波 on 13-4-25.
//  Copyright (c) 2013年 Kong XiangBo. All rights reserved.
//

#import "KKViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface KKViewController ()

@end
double radians(float degrees) {
    return ( degrees * 3.14159265 ) / 180.0;
}
@implementation KKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _staus = YES;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender {
    CALayer *downLayer = _downView.layer;
    downLayer.anchorPoint= CGPointMake(0.5, 1);
    CALayer *upLayer = _upView.layer;
    upLayer.anchorPoint= CGPointMake(0.5, 0);
    
    CGFloat angle;
    if (_staus) {
        angle = 45;
    }else{
        angle = -45;
    }
    [downLayer addAnimation:[self leafsAnimation:CGPointMake(_downView.center.x,_downView.center.y)
                                       angle:angle
                                          Animationname:@"wahaha"] forKey:@"position"];
    
    [upLayer addAnimation:[self leafsAnimation:CGPointMake(_upView.center.x,_upView.center.y)
                                           angle:-angle
                                   Animationname:@"wahaha"] forKey:@"position"];
   // downLayer.anchorPoint= CGPointMake(0.5, 0);
//    _downView.center = CGPointMake(_downView.center.x,_downView.center.y-_downView.frame.size.height/2);
}
-(CAAnimation*)leafsAnimation:(CGPoint)fromPoint angle:(CGFloat)angel Animationname:(NSString *)name
{
    float t1=10;
     
    CAKeyframeAnimation *move0 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef thePath0 = CGPathCreateMutable();
	CGPathMoveToPoint(thePath0, NULL, fromPoint.x, fromPoint.y);
	CGPathAddLineToPoint(thePath0, NULL, fromPoint.x, fromPoint.y);
    
	move0.duration=t1;
	move0.path = thePath0;
	CGPathRelease(thePath0);
    
    
    CAKeyframeAnimation *move = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	move.removedOnCompletion = YES;
    move.beginTime = 0;
	move.duration = t1;
	
    
    
    CATransform3D to=CATransform3DMakeRotation(radians(angel), 1, 0, 0);
    to.m34 = 1/ 10.0;
	move.values = [NSArray arrayWithObjects:
                   [NSValue valueWithCATransform3D:CATransform3DMakeRotation(radians(0), 0, 0, 0)],
                   [NSValue valueWithCATransform3D:to],nil];
    move.keyTimes = [NSArray arrayWithObjects:
                     [NSNumber numberWithFloat:0.0],
					 [NSNumber numberWithFloat:1.0],nil];
    CAAnimationGroup *group = [CAAnimationGroup animation];
	group.duration = t1;
	group.delegate = self;
	[group setValue:name forKey:@"name"];
	//move.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
	group.animations = [NSArray arrayWithObjects:move0,move,nil];
	return group;
    
}
- (IBAction)open:(id)sender {
}
@end
