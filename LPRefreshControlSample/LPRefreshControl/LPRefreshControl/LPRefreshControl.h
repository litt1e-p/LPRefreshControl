//
//  LPRefreshControl.h
//  LPRefreshControl
//
//  Created by litt1e-p on 16/1/9.
//  Copyright © 2016年 litt1e-p. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RefreshPosition)
{
    RefreshPositionTop,
    RefreshPositionBottom
};

@interface LPRefreshControl : NSObject

+ (instancetype)sharedInstance;

- (void)addRefreshInView:(UIScrollView *)view
              atPosition:(RefreshPosition)position
             withHandler:(void (^)(void))handler;
- (void)addRefreshInView:(UIScrollView *)view
          withTopHandler:(void (^)(void))topHandler
        andBottomHandler:(void (^)(void))bottomHandler;
- (void)triggerRefreshInView:(UIScrollView *)view
                  atPosition:(RefreshPosition)position;
- (void)stopAnimatingInView:(UIScrollView *)view
                 atPosition:(RefreshPosition)position;

@end
