//
//  KKViewController.h
//  refreshDemo
//
//  Created by 孔祥波 on 13-4-25.
//  Copyright (c) 2013年 Kong XiangBo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKRefreshTableHeaderView.h"
@interface KKViewController : UITableViewController <KKRefreshTableHeaderViewDelegate, UITableViewDelegate, UITableViewDataSource>{
	
	KKRefreshTableHeaderView *_refreshHeaderView;
	
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes
	BOOL _reloading;
}

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
@end
