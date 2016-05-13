//
//  PlayerNavigationView.h
//  VideoPlayerTest
//
//  Created by shenzhenshihua on 16/5/11.
//  Copyright © 2016年 shenzhenshihua. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AVPlayer;

@protocol PlayerNavigationDelegate <NSObject>

- (void)playerNavgationViewBack;

@end

@interface PlayerNavigationView : UIView
@property (nonatomic,assign)id <PlayerNavigationDelegate>delegate;

- (id)initWithFrame:(CGRect)frame andPlayer:(AVPlayer*)player;
- (void)adjustTheHorizontalSizeOfTheControl;
- (void)adjustTheSizeOfTheControlOrdinate;
- (void)removeObserver;

@end
