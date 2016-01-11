//
//  LPRefreshView.h
//  LPRefreshControl
//
//  Created by litt1e-p on 16/1/9.
//  Copyright © 2016年 litt1e-p. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RefreshState)
{
    RefreshStateStopped,
    RefreshStateLoading,
    RefreshStateTriggered,
    RefreshStateAll
};

@interface LPRefreshView : UIView

@property (nonatomic, assign) RefreshState refreshState;

@end
