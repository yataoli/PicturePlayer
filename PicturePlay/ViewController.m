//
//  ViewController.m
//  PicturePlay
//
//  Created by suge on 16/7/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ViewController.h"
#import "PicturePlayer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    PicturePlayer *imageScrollView = [[PicturePlayer alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200) andImageArray:@[@"http://p71yuflyr.bkt.clouddn.com/playPicture1.jpg",@"http://p71yuflyr.bkt.clouddn.com/playPicture2.jpg",@"http://p71yuflyr.bkt.clouddn.com/playPicture3.jpg",@"http://p71yuflyr.bkt.clouddn.com/guideImageOne.jpeg",@"http://p71yuflyr.bkt.clouddn.com/guideImageTwo.jpeg"]];
    [self.view addSubview:imageScrollView];
    imageScrollView.indexBlock = ^void(NSInteger index){
        NSLog(@"点击了第%ld张", (long)index);
    };

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
