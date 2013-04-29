//
//  KKFlodView.m
//  refreshDemo
//
//  Created by 孔祥波 on 13-4-29.
//  Copyright (c) 2013年 Kong XiangBo. All rights reserved.
//

#import "KKFlodView.h"
double radians(float degrees) {
    return ( degrees * 3.14159265 ) / 180.0;
}

@implementation KKFlodView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        containView = [[UIView alloc] initWithFrame:self.bounds];
        containView.backgroundColor = [UIColor redColor];
        containView.alpha = 0.5;
        [containView setAutoresizesSubviews:YES];
        [containView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        
        [self addSubview:containView];
        containLayer=containView.layer;
        
        upView=[[UIView alloc] initWithFrame:CGRectMake(0, 3*frame.size.height/4, self.bounds.size.width, frame.size.height/2)];
        
        upView.backgroundColor = [UIColor cyanColor];
        downView= [[UIView alloc] initWithFrame:CGRectMake(0,  3*frame.size.height/4, self.bounds.size.width, frame.size.height/2)];
        
        downView.backgroundColor = [UIColor yellowColor];
       
        [containView addSubview:upView];
        [containView addSubview:downView];
        
        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = -1/100.0;
        [containView.layer setSublayerTransform:transform];
        
        [upView.layer setAnchorPoint:CGPointMake(0.5, 0.0)];
        [downView.layer setAnchorPoint:CGPointMake(0.5, 1.0)];
        // make sure the views are closed properly when initialized
        [downView.layer setTransform:CATransform3DMakeRotation((M_PI / 2), 1, 0, 0)];
        CATransform3D transform1 = CATransform3DMakeTranslation(0, -2*downView.frame.size.height, 0);
        CATransform3D transform2 = CATransform3DMakeRotation((M_PI / 2) , -1, 0, 0);
        CATransform3D transform21 = CATransform3DConcat(transform2, transform1);
        [upView.layer setTransform:transform21];
        
        [self setAutoresizesSubviews:YES];
        [self setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    }
    return self;
}
- (void)unfoldViewToFraction:(CGFloat)fraction
{
    float delta = asinf(fraction);
    
    // rotate bottomView on the left edge of the view
    [downView.layer setTransform:CATransform3DMakeRotation((M_PI / 2) - delta, 1, 0, 0)];
    
    // rotate topView on the right edge of the view
    // translate rotated view to the bottom to join to the edge of the bottomView
    CATransform3D transform1 = CATransform3DMakeTranslation(0, -2*downView.frame.size.height, 0);
    CATransform3D transform2 = CATransform3DMakeRotation((M_PI / 2) - delta, -1, 0, 0);
    CATransform3D transform = CATransform3DConcat(transform2, transform1);
    [upView.layer setTransform:transform];
    
    // fade in shadow when folding
    // fade out shadow when unfolding
//    [self.bottomView.shadowView setAlpha:1-fraction];
//    [self.topView.shadowView setAlpha:1-fraction];
}
- (void)unfoldWithParentOffset2:(float)offset
{
    float a = offset/self.bounds.size.height;
    float angle = 90;
    [CATransaction begin];
    
    
    float c = sinf(radians(angle*(1-a)));
    float d = cosf(radians(angle*(1-a)));
    
    
    

    //NSLog(@"_downLayer %@, _upLayer %@",[_downLayer debugDescription],[_upLayer debugDescription]);
    self.frame = CGRectMake(0, self.frame.origin.y, 320, self.bounds.size.height-offset);
    //[CATransaction commit];
    
    
    [CATransaction setDisableActions:YES];
    CATransform3D upTransform=CATransform3DMakeRotation(radians((a-1)*angle), 1, 0, 0);
    //CATransform3DTranslate(upTransform, 0, -26, 0);
    
    CATransform3D downTransform=CATransform3DMakeRotation(radians((1-a)*angle), 1, 0, 0);
    //CATransform3DTranslate(downTransform, 0, 26, 0);
    
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    
    
    //    _upLayer.transform = upTransform;
    //    _downLayer.transform = downTransform;
    
    
    [CATransaction setCompletionBlock:^{
        upView.layer.transform = upTransform;
        downView.layer.transform = downTransform;
//        NSLog(@"%f",_upLayer.position.y);
//        NSLog(@"%f",_downLayer.position.y);
        
    }];
    //[CATransaction commit];
    
    
    [CATransaction commit];
}
- (void)unfoldWithParentOffset:(float)offset
{
    [self calculateFoldStateFromOffset:offset];
    NSLog(@"%f",offset);
    CGFloat fraction = 0.0;
   
        fraction = offset / self.frame.size.height;
        if (fraction < 0) fraction = -1*fraction;
        if (fraction > 1) fraction = 1;
    
   [self unfoldViewToFraction:fraction];
}
- (void)calculateFoldStateFromOffset:(float)offset
{
    CGFloat fraction = 0.0;
   
        fraction = offset / self.frame.size.height;
        if (fraction < 0) fraction = -1*fraction;
        if (fraction > 1) fraction = 1;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
