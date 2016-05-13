//
//  VideoPlayerVC.m
//  VideoPlayerTest
//
//  Created by shenzhenshihua on 16/5/11.
//  Copyright © 2016年 shenzhenshihua. All rights reserved.
//
#define Screen_Frame     [[UIScreen mainScreen] bounds]
#define Screen_Width     [[UIScreen mainScreen] bounds].size.width
#define Screen_Height    [[UIScreen mainScreen] bounds].size.height

#import "VideoPlayerVC.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "PlayerNavigationView.h"
#import "PlayerToolBarView.h"
@interface VideoPlayerVC ()<PlayerNavigationDelegate>
@property(nonatomic,retain)AVPlayer * player;
@property(nonatomic,retain)UIView * playerView;
@property(nonatomic,strong)UIActivityIndicatorView * activiityIndicator;//小菊花
@property(nonatomic,strong) AVPlayerLayer * thePlayLayer;//播放视频图层
@property (nonatomic,assign,getter=isOpened)BOOL opened;//控制栏是否隐藏
@property(nonatomic,strong)PlayerNavigationView * navigationView;
@property(nonatomic,strong)PlayerToolBarView * toolBarView;
@property(nonatomic,assign)NSInteger tempVaule;
@end

@implementation VideoPlayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    [self initPlayerView];
    [self initPlayer];
    [self layoutNavigationBarView];
    [self layoutToolBarView];
    [self initNsnotificationCenter];//注册通知中心
    
    // Do any additional setup after loading the view.
}


- (void)initPlayerView{

    if (self.playerView==nil) {
        self.playerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
        self.playerView.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchBegan)];
        [self.playerView addGestureRecognizer:tap];
        
        [self.view addSubview:self.playerView];
        
        self.activiityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        self.activiityIndicator.center = self.view.center;

        [self.activiityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.activiityIndicator.hidesWhenStopped = YES;
        [self.view addSubview:self.activiityIndicator];
        _tempVaule = 0;
        if (self.videoUrlStr.length != 0) {
            [self.activiityIndicator startAnimating];//小菊花开始转起来
        }

    }



}

- (void)initPlayer{

    NSURL * flashUrl = [NSURL URLWithString:self.videoUrlStr];
    
    AVAsset * asset = [AVAsset assetWithURL:flashUrl];
    AVPlayerItem * playerItem = [AVPlayerItem playerItemWithAsset:asset];
    self.player = [AVPlayer playerWithPlayerItem:playerItem];
    
    
    __weak typeof (self)ws = self;
    [ws.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 30) queue:nil usingBlock:^(CMTime time) {
        CMTime durtionTime = [ws getPlayerItemDurtion:playerItem];
        [ws  updatePlayHeadWithTime:time duration:durtionTime];
    }];
    
    
    [self.player addObserver:self forKeyPath:@"rate" options:0 context:@"contentPlayerRate"];
    self.thePlayLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.thePlayLayer.frame = self.playerView.bounds;
    self.thePlayLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.playerView.layer addSublayer:self.thePlayLayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contentDidFishPalying) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [self.player play];
    
}


//视频完成播放
- (void)contentDidFishPalying{
    
    [self.activiityIndicator stopAnimating];
}

/**
 *  显示与隐藏控制栏
 */
- (void)touchBegan{
    CGRect NavFrame = self.navigationView.frame;
    CGRect ToolBarFrame = self.toolBarView.frame;
    if (self.opened) {
        NavFrame.origin.y = -64;
        ToolBarFrame.origin.y = CGRectGetMaxY(self.playerView.frame);
        [UIView animateWithDuration:0.3 animations:^{
            self.navigationView.frame = NavFrame;
            self.toolBarView.frame = ToolBarFrame;
            
        }];
        
        
    }else{
        NavFrame.origin.y = 0;
        ToolBarFrame.origin.y = CGRectGetMaxY(self.playerView.frame)-64;
        [UIView animateWithDuration:0.3 animations:^{
            self.navigationView.frame = NavFrame;
            self.toolBarView.frame = ToolBarFrame;
            
        }];

    
    }

    self.opened = !self.opened;

}
#pragma mark KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    

        if (context == @"contentPlayerRate" && self.player == object) {

            if (self.player.rate == 0) {
//                [videoToolBar  selectedStopOrStart:NO];
                [self.activiityIndicator startAnimating];
            }else{
//                [videoToolBar  selectedStopOrStart:YES];
                [self.activiityIndicator stopAnimating];
            }
        }

}

//自定义导航栏
- (void)layoutNavigationBarView{
    self.navigationView = [[PlayerNavigationView alloc] initWithFrame:CGRectMake(0, -64, Screen_Width, 64) andPlayer:self.player];
    self.navigationView .backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    _navigationView.delegate = self;
    [self.playerView addSubview:self.navigationView];
    
    
    
}
#pragma mark=======PlayNavigationdelegate

- (void)playerNavgationViewBack{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [self.player removeObserver:self forKeyPath:@"rate" context:@"contentPlayerRate"];
    /**
     *  移除音量的监听
     */
    [_navigationView removeObserver];
    
    _navigationView = nil;
    _toolBarView = nil;
    
    [self.player pause];
    self.player = nil;
    
    
    [self.navigationController popViewControllerAnimated:YES];
    

}
//自定义底部导航栏
- (void)layoutToolBarView{
    self.toolBarView = [[PlayerToolBarView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.playerView.frame), Screen_Width, 64) AndPlayer:self.player];
    
    self.toolBarView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    [self.playerView addSubview:self.toolBarView];
    
}


#pragma mark -----------------------------时间方面的处理
//转化成时间CMTime
- (CMTime)getPlayerItemDurtion:(AVPlayerItem *)palyerItem{
    CMTime durtionTime = kCMTimeInvalid;
    if ([palyerItem respondsToSelector:@selector(duration)]) {
        durtionTime = palyerItem.duration;
    }else if(palyerItem.asset && [palyerItem.asset respondsToSelector:@selector(duration)]){
        durtionTime = palyerItem.asset.duration;
    }
    return durtionTime;
}

//当前时间和总时间
- (void)updatePlayHeadWithTime:(CMTime)time duration:(CMTime)duration{
    if (CMTIME_IS_INVALID(time)) {
        return;
    }
    Float64 currentTime = CMTimeGetSeconds(time);
    if (isnan(currentTime)) {
        return;
    }
//    videoToolBar.progressSlider.value = currentTime;
    NSString * timeString = [NSString stringWithFormat:@"%d:%02d",(int)currentTime/60,(int)currentTime%60];
//    NSLog(@"当前全部时间 %f",currentTime);
//    NSLog(@"当前进度时间%@",timeString);
    [_toolBarView customVideoCurrentVaule:timeString andCurrentVilue:currentTime];
    
    [self updatePlayHeadDurationWithTime:duration];
}

//总时间
- (void)updatePlayHeadDurationWithTime:(CMTime)durationTime{
    if (CMTIME_IS_INVALID(durationTime)) {
        return;
    }
    Float64 druationTime = CMTimeGetSeconds(durationTime);
    if (isnan(druationTime)) {
        return;
    }
    NSString * timeString = [NSString stringWithFormat:@"%d:%02d",(int)druationTime/60,(int)druationTime%60];

    [_toolBarView customVideoSumTimeVaule:timeString];
    _toolBarView.progressSlider.maximumValue = druationTime;
}


#pragma mark ---
#pragma mark 横竖屏监听
- (void)initNsnotificationCenter{//UIDeviceOrientationDidChangeNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rotateFlashOriginaleVideoView:) name:UIDeviceOrientationDidChangeNotification object:nil];
 
}


//监听处理横竖屏问题
- (void)rotateFlashOriginaleVideoView:(NSNotification *)notification{
   
    int vaule = [[UIDevice currentDevice] orientation];
    
    
    NSLog(@"方向 -------- %d tempVaule -- %ld",vaule,(long)_tempVaule);
    NSLog(@"a:%f b:%f c:%f d:%f x:%f y:%f",self.view.transform.a,self.view.transform.b,self.view.transform.c,self.view.transform.d,self.view.transform.tx,self.view.transform.ty);
    
    if (vaule == 1 || vaule == 2 || vaule == 3 || vaule == 4) {
        if (_tempVaule != vaule) {
           

            ///MPNLog(@"======>%f",self.frame.size.width);
            if (_tempVaule == 3 || _tempVaule == 4) {
                if (vaule == 1 ) {

                    self.view.frame = CGRectMake(0, 0, Screen_Height, Screen_Width);
                    self.view.center = CGPointMake(Screen_Width/2, Screen_Height/2);
                    CGAffineTransform rotate = CGAffineTransformIdentity;
                    [self.view setTransform:rotate];
                    [self  verticalScreenAdaptation];
                    _tempVaule = vaule;
            
                    
                }
                else if (vaule == 2){
                    self.view.frame = CGRectMake(0, 0, Screen_Height, Screen_Width);
                    self.view.center = CGPointMake(Screen_Width/2, Screen_Height/2);
                    CGAffineTransform rotate = CGAffineTransformMakeRotation(-M_PI);
                    [self.view setTransform:rotate];
                    [self  verticalScreenAdaptation];
                    _tempVaule = vaule;
                    
                }
               
            }else{
                if(vaule == 3){
                    
                    self.view.frame = CGRectMake(0, 0, Screen_Height, Screen_Width);
                    self.view.center = CGPointMake(Screen_Width/2, Screen_Height/2);
                    CGAffineTransform rotate = CGAffineTransformMakeRotation(M_PI/2);
                    [self.view setTransform:rotate];
                    [self  autoTheSize];
                     _tempVaule = vaule;
                }
                else if(vaule == 4){
                    
                    self.view.frame = CGRectMake(0, 0, Screen_Height, Screen_Width);
                    self.view.center = CGPointMake(Screen_Width/2, Screen_Height/2);
                    CGAffineTransform rotate = CGAffineTransformMakeRotation(M_PI*1.5);
                    [self.view setTransform:rotate];
                    [self  autoTheSize];
                     
 
                    _tempVaule = vaule;
                    
                }
            }
        }

    }
    

    
}
//横屏
- (void)autoTheSize{
        _navigationView.frame = CGRectMake(0, 0, Screen_Height, 64);
    
        self.playerView.frame = CGRectMake(0, 0, Screen_Height, Screen_Width);
        _thePlayLayer.frame = self.playerView.bounds;
        _toolBarView.frame = CGRectMake(0, CGRectGetMaxY(self.playerView.frame) - 64, Screen_Height, 64);
        _activiityIndicator.center = CGPointMake(Screen_Height/2, Screen_Width/2);
    [_navigationView adjustTheHorizontalSizeOfTheControl];
    [_toolBarView adjustTheHorizontalSizeOfTheControl];
}

//竖屏
- (void)verticalScreenAdaptation{
          _navigationView.frame = CGRectMake(0, 0, Screen_Width, 64);
        self.playerView.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
        _thePlayLayer.frame = self.playerView.bounds;
        _toolBarView.frame = CGRectMake(0, CGRectGetMaxY(self.playerView.frame) - 64, Screen_Width, 64);
        _activiityIndicator.center = CGPointMake(Screen_Width/2, Screen_Height/2);
    [_navigationView adjustTheSizeOfTheControlOrdinate];
    [_toolBarView adjustTheSizeOfTheControlOrdinate];

}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
