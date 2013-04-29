//
//  KKFlodView.h
//  refreshDemo
//
//  Created by 孔祥波 on 13-4-29.
//  Copyright (c) 2013年 Kong XiangBo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface KKFlodView : UIView{
    UIView *upView;
    UIView *downView;
    UIView *containView;
    CALayer *containLayer;
}
- (void)unfoldWithParentOffset:(float)offset;
@end
