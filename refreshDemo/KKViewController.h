//
//  KKViewController.h
//  refreshDemo
//
//  Created by 孔祥波 on 13-4-25.
//  Copyright (c) 2013年 Kong XiangBo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *upView;
@property (strong, nonatomic) IBOutlet UIView *downView;
@property (nonatomic) BOOL staus;
- (IBAction)close:(id)sender;
- (IBAction)open:(id)sender;

@end
