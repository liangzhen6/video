//
//  PlayerToolBarView.h
//  VideoPlayerTest
//
//  Created by shenzhenshihua on 16/5/11.
//  Copyright © 2016年 shenzhenshihua. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AVPlayer;
@interface PlayerToolBarView : UIView

@property(nonatomic,retain)UISlider * progressSlider;

- (id)initWithFrame:(CGRect)frame AndPlayer:(AVPlayer *)player;

- (void)customVideoCurrentVaule:(NSString *)currentVauleString andCurrentVilue:(Float64)value;
- (void)customVideoSumTimeVaule:(NSString *)sumTimeString;


- (void)adjustTheHorizontalSizeOfTheControl;
- (void)adjustTheSizeOfTheControlOrdinate;

@end
