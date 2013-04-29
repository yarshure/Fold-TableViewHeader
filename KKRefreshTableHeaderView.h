//
//  KKRefreshTableHeaderView.h
//  refreshDemo
//
//  Created by 孔祥波 on 13-4-26.
//  Copyright (c) 2013年 Kong XiangBo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "KKFlodView.h"
typedef enum{
	KKPullRefreshPulling = 0,
	KKPullRefreshNormal,
	KKPullRefreshLoading,
} KKPullRefreshState;

@protocol KKRefreshTableHeaderViewDelegate;

@interface KKRefreshTableHeaderView : UIView {
	
	__weak id _delegate ;
	KKPullRefreshState _state;
    
	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;
	KKFlodView *foldView;
    
}

@property(nonatomic,weak) id <KKRefreshTableHeaderViewDelegate> delegate;

- (void)refreshLastUpdatedDate;
- (void)kkRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)kkRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)kkRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end


@protocol KKRefreshTableHeaderViewDelegate
- (void)kkRefreshTableHeaderDidTriggerRefresh:(KKRefreshTableHeaderView*)view;
- (BOOL)kkRefreshTableHeaderDataSourceIsLoading:(KKRefreshTableHeaderView*)view;
@optional
- (NSDate*)kkRefreshTableHeaderDataSourceLastUpdated:(KKRefreshTableHeaderView*)view;
@end
