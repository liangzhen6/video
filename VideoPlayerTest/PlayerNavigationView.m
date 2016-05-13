//
//  PlayerNavigationView.m
//  VideoPlayerTest
//
//  Created by shenzhenshihua on 16/5/11.
//  Copyright © 2016年 shenzhenshihua. All rights reserved.
//

#import "PlayerNavigationView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
@interface PlayerNavigationView ()
@property(nonatomic,strong)AVPlayer * player;
@property(nonatomic,strong)UIImageView *backImageView;
@property(nonatomic,strong)UIImageView *voiceImageView;
@property(nonatomic,strong)UISlider *voiceSlider;
//@property(nonatomic,strong)MPVolumeView * volumeView;
@end

@implementation PlayerNavigationView

- (id)initWithFrame:(CGRect)frame andPlayer:(AVPlayer*)player{
    self = [super initWithFrame:frame];
    if (self) {
        self.player = player;
        [self initView];
        [self addNotificationCenter];
    }

    return self;
}

- (void)initView{
    _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 26, 44, 30)];
    _backImageView.backgroundColor = [UIColor clearColor];
    _backImageView.contentMode = UIViewContentModeScaleAspectFit;
    _backImageView.image = [UIImage imageNamed:@"goBack.png"];
    _backImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer * goBackTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playerContainerGoBack:)];
    [_backImageView  addGestureRecognizer:goBackTap];
    [self addSubview:_backImageView];

    _voiceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_backImageView.frame)+20, 26, 30, 30)];
    _voiceImageView.contentMode = UIViewContentModeScaleAspectFill;
    _voiceImageView.image = [UIImage imageNamed:@"sound-on"];
    [self addSubview:_voiceImageView];

    
    _voiceSlider = [[UISlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_voiceImageView.frame)+10, 30, self.frame.size.width-180, 20)];
    _voiceSlider.backgroundColor = [UIColor clearColor];
    _voiceSlider.userInteractionEnabled = YES;
    _voiceSlider.maximumValue = 1.0;
    
    [_voiceSlider addTarget:self action:@selector(soundAdjustment:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_voiceSlider];
    
    _voiceSlider.value = [MPMusicPlayerController applicationMusicPlayer].volume;
    
    if (_voiceSlider.value==0) {
        _voiceImageView.image = [UIImage imageNamed:@"sound-off"];
    }
}
/**
 *  注册通知检测系统音量
 */
- (void)addNotificationCenter{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(volumeChanged:)
                                                 name:@"AVSystemController_SystemVolumeDidChangeNotification"
                                               object:nil];
}

- (void)removeObserver{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];

}
- (void)soundAdjustment:(UISlider*)voluemeSet{

         MPMusicPlayerController * mpc = [MPMusicPlayerController applicationMusicPlayer];
        mpc.volume = voluemeSet.value;
//        NSLog(@"%f@@@@@@",voluemeSet.value);

    
}

- (void)volumeChanged:(NSNotification*)notification{
    CGFloat volume =
    [[[notification userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"]floatValue];
    _voiceSlider.value = volume;
//    NSLog(@"%f@@@@@@",volume);

    if (_voiceSlider.value==0) {
        _voiceImageView.image = [UIImage imageNamed:@"sound-off"];
    }else{
        _voiceImageView.image = [UIImage imageNamed:@"sound-on"];
    
    }
}
/**
 *  返回事件
 *
 *  @param clickTap
 */
- (void)playerContainerGoBack:(UITapGestureRecognizer*)clickTap{
    
    if ([self.delegate respondsToSelector:@selector(playerNavgationViewBack)]) {
        [self.delegate playerNavgationViewBack];
    }
}
/**
 *  横屏
 */
- (void)adjustTheHorizontalSizeOfTheControl{
    
    _backImageView.frame = CGRectMake(10, 26, 44, 30);
//    CGFloat X = self.frame.size.width/2-(_voiceImageView.frame.size.width+_voiceSlider.frame.size.width+10)/2;
    
    _voiceImageView.frame = CGRectMake(CGRectGetMaxX(_backImageView.frame)+50, 26, 30, 30);
    
    _voiceSlider.frame = CGRectMake(CGRectGetMaxX(_voiceImageView.frame)+10, 30, _voiceSlider.frame.size.width+50, 20);

//    CGRect volumeViewframe = _voiceImageView.frame;
//    volumeViewframe.origin.x = X;
//    _voiceImageView.frame = volumeViewframe;
//    
//    CGRect voiceSliderframe = _voiceSlider.frame;
//    voiceSliderframe.origin.x = X+40;
//    _voiceSlider.frame = voiceSliderframe;
    
    

}
/**
 *  竖屏
 */
- (void)adjustTheSizeOfTheControlOrdinate{
  

    _backImageView.frame = CGRectMake(10, 26, 44, 30);
    _voiceImageView.frame = CGRectMake(CGRectGetMaxX(_backImageView.frame)+20, 26, 30, 30);
    
    _voiceSlider.frame = CGRectMake(CGRectGetMaxX(_voiceImageView.frame)+10, 30, self.frame.size.width-180, 20);

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
