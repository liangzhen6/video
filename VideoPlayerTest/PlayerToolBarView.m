//
//  PlayerToolBarView.m
//  VideoPlayerTest
//
//  Created by shenzhenshihua on 16/5/11.
//  Copyright © 2016年 shenzhenshihua. All rights reserved.
//

#import "PlayerToolBarView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
@interface PlayerToolBarView ()
@property(nonatomic,strong)AVPlayer * player;


@property(nonatomic,strong)UIButton * stopOrStrart;
@property(nonatomic,strong)UILabel * currentTime;
@property(nonatomic,strong)UILabel * sumTime;

@end

@implementation PlayerToolBarView

- (id)initWithFrame:(CGRect)frame AndPlayer:(AVPlayer *)player{

    self = [super initWithFrame:frame];
    if (self) {
        self.player = player;
        [self initView];
        
    }
    return self;
}

- (void)initView{
    _stopOrStrart = [UIButton buttonWithType:UIButtonTypeCustom];
    _stopOrStrart.frame = CGRectMake(20, 10, 50, 30);
    [_stopOrStrart setTitle:@"開始" forState:UIControlStateNormal];
    [_stopOrStrart setTitle:@"暫停" forState:UIControlStateSelected];
    _stopOrStrart.selected = YES;
    [_stopOrStrart addTarget:self action:@selector(videoPlayerOrPauseEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_stopOrStrart];
    
    
    
    _currentTime = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_stopOrStrart.frame), 10, 50, 30)];
  
    _currentTime.textColor = [UIColor whiteColor];
    _currentTime.numberOfLines = 0;
    _currentTime.text = @"00:00";
    _currentTime.backgroundColor = [UIColor clearColor];
    [self addSubview:_currentTime];
    
    self.progressSlider = [[UISlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_currentTime.frame), 13, self.frame.size.width-70-50-70-20, 20)];
    
    [self.progressSlider addTarget:self action:@selector(progressSliderViewTakeAction:) forControlEvents:UIControlEventValueChanged];

    [self.progressSlider addTarget:self action:@selector(progressSliderBeganAction:) forControlEvents:UIControlEventTouchUpInside];
   
    
    [self addSubview:self.progressSlider];
    
    _sumTime = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.progressSlider.frame)+10, 10, 60, 30)];
    
    _sumTime.textColor = [UIColor whiteColor];
    _sumTime.numberOfLines = 0;
    _sumTime.text = @"00:00";
    _sumTime.backgroundColor = [UIColor clearColor];
    [self addSubview:_sumTime];



}

#pragma mark PublicModth
- (void)customVideoCurrentVaule:(NSString *)currentVauleString andCurrentVilue:(Float64)value{
    _currentTime.text = currentVauleString;
    _progressSlider.value = value;
}
- (void)customVideoSumTimeVaule:(NSString *)sumTimeString{
    _sumTime.text = sumTimeString;
}

- (void)progressSliderViewTakeAction:(UISlider *)slider{
  [self.player pause];
    _stopOrStrart.selected = NO;
  [self.player seekToTime:CMTimeMake(slider.value, 1)];
    
}
- (void)progressSliderBeganAction:(UISlider *)slider{
    [self.player play];
    _stopOrStrart.selected = YES;
   
    
}
#pragma mark Target
- (void)videoPlayerOrPauseEvent:(UIButton *)button{
     _stopOrStrart.selected = ! _stopOrStrart.selected;
    if (_stopOrStrart.selected) {
        [self.player play];
    }else{
        [self.player pause];
    
    }
   
}
/**
 *  横屏
 */
- (void)adjustTheHorizontalSizeOfTheControl{

    
    _stopOrStrart.frame = CGRectMake(50, 10, 50, 30);
    _currentTime.frame = CGRectMake(CGRectGetMaxX(_stopOrStrart.frame), 10, 50, 30);
    self.progressSlider.frame = CGRectMake(CGRectGetMaxX(_currentTime.frame), 13, self.progressSlider.frame.size.width+50, 20);
    
    _sumTime.frame = CGRectMake(CGRectGetMaxX(self.progressSlider.frame)+10, 10, 60, 30);

}
/**
 *  竖屏
 */
- (void)adjustTheSizeOfTheControlOrdinate{
    _stopOrStrart.frame = CGRectMake(20, 10, 50, 30);
    _currentTime.frame = CGRectMake(CGRectGetMaxX(_stopOrStrart.frame), 10, 50, 30);
    self.progressSlider.frame = CGRectMake(CGRectGetMaxX(_currentTime.frame), 13, self.progressSlider.frame.size.width-50, 20);

    _sumTime.frame = CGRectMake(CGRectGetMaxX(self.progressSlider.frame)+10, 10, 60, 30);
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
