//
//  KKRefreshTableHeaderView.m
//  refreshDemo
//
//  Created by 孔祥波 on 13-4-26.
//  Copyright (c) 2013年 Kong XiangBo. All rights reserved.
//

#import "KKRefreshTableHeaderView.h"
#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f
#define kHeight 40
double radians(float degrees) {
    return ( degrees * 3.14159265 ) / 180.0;
}
@interface KKRefreshTableHeaderView (Private)
- (void)setState:(KKPullRefreshState)aState;
@end

@implementation KKRefreshTableHeaderView


@synthesize  delegate = _delegate;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:12.0f];
		label.textColor = TEXT_COLOR;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_lastUpdatedLabel=label;
		
		
		label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:13.0f];
		label.textColor = TEXT_COLOR;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		
		
		CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake(25.0f, frame.size.height - 65.0f, 30.0f, 55.0f);
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:@"blueArrow.png"].CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(25.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
		
		
        
        upView=[[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-2*kHeight, self.bounds.size.width, kHeight)];
        upView.backgroundColor = [UIColor cyanColor];
        downView= [[UIView alloc] initWithFrame:CGRectMake(0,  frame.size.height-1*kHeight, self.bounds.size.width,kHeight)];
        
        downView.backgroundColor = [UIColor yellowColor];
        
        [self addSubview:upView];
        [self addSubview:downView];
		[self setState:KKPullRefreshNormal];
		
    }
	
    return self;
	
}

- (IBAction)close:(id)sender {
    CALayer *downLayer = downView.layer;
    downLayer.anchorPoint= CGPointMake(0.5, 1);
    CALayer *upLayer = upView.layer;
    upLayer.anchorPoint= CGPointMake(0.5, 0);
    
    BOOL _staus = NO;
    CGFloat angle;
    if (_staus) {
        angle = 45;
    }else{
        angle = -45;
    }
    [downLayer addAnimation:[self leafsAnimation:CGPointMake(downView.center.x,downView.center.y)
                                           angle:angle
                                   Animationname:@"wahaha"] forKey:@"position"];
    
    [upLayer addAnimation:[self leafsAnimation:CGPointMake(upView.center.x,upView.center.y)
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

#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {
	
	if ([_delegate respondsToSelector:@selector(kkRefreshTableHeaderDataSourceLastUpdated:)]) {
		
		NSDate *date = [_delegate kkRefreshTableHeaderDataSourceLastUpdated:self];
		
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setAMSymbol:@"AM"];
		[formatter setPMSymbol:@"PM"];
		[formatter setDateFormat:@"MM/dd/yyyy hh:mm:a"];
		_lastUpdatedLabel.text = [NSString stringWithFormat:@"Last Updated: %@", [formatter stringFromDate:date]];
		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"KKRefreshTableView_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
		
	} else {
		
		_lastUpdatedLabel.text = nil;
		
	}
    
}

- (void)setState:(KKPullRefreshState)aState{
	
	switch (aState) {
		case KKPullRefreshPulling:
			
			_statusLabel.text = NSLocalizedString(@"Release to refresh...", @"Release to refresh status");
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			break;
		case KKPullRefreshNormal:
			
			if (_state == KKPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
			_statusLabel.text = NSLocalizedString(@"Pull down to refresh...", @"Pull down to refresh status");
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			[self refreshLastUpdatedDate];
			
			break;
		case KKPullRefreshLoading:
			
			_statusLabel.text = NSLocalizedString(@"Loading...", @"Loading Status");
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)kkRefreshScrollViewDidScroll:(UIScrollView *)scrollView {
	
	if (_state == KKPullRefreshLoading) {
		
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 60);
		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
		
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(kkRefreshTableHeaderDataSourceIsLoading:)]) {
			_loading = [_delegate kkRefreshTableHeaderDataSourceIsLoading:self];
		}
		
		if (_state == KKPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_loading) {
			[self setState:KKPullRefreshNormal];
		} else if (_state == KKPullRefreshNormal && scrollView.contentOffset.y < -65.0f && !_loading) {
			[self setState:KKPullRefreshPulling];
		}
		
		if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
		
	}
	
}

- (void)kkRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(kkRefreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [_delegate kkRefreshTableHeaderDataSourceIsLoading:self];
	}
	
	if (scrollView.contentOffset.y <= - 65.0f && !_loading) {
		
		if ([_delegate respondsToSelector:@selector(kkRefreshTableHeaderDidTriggerRefresh:)]) {
			[_delegate kkRefreshTableHeaderDidTriggerRefresh:self];
		}
		
		[self setState:KKPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
		
	}
	
}

- (void)kkRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[self setState:KKPullRefreshNormal];
    
}


#pragma mark -
#pragma mark Dealloc


@end
