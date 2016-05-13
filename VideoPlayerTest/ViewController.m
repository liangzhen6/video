//
//  ViewController.m
//  VideoPlayerTest
//
//  Created by shenzhenshihua on 16/5/11.
//  Copyright © 2016年 shenzhenshihua. All rights reserved.
/*
 http://10.19.2.2/201511/HET20151124_01.mp4
 http://10.19.2.2/201511/HET20151124_02.mp4
 http://10.19.2.2/201511/HET20151124_03.mp4
 */

#import "ViewController.h"
#import "VideoPlayerVC.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    VideoPlayerVC * video = [[VideoPlayerVC alloc] init];
    video.videoUrlStr = @"http://10.19.2.2/201511/HET20151124_01.mp4";
    
    [self.navigationController pushViewController:video animated:YES];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
