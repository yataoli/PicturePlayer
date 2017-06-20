//
//  PicturePlayer.h
//  PicturePlay
//
//  Created by suge on 16/7/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^totalBlock) (NSInteger);
@interface PicturePlayer : UIView <UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) NSArray *imageNameArray;//存放图片名称的数组
@property (nonatomic) NSInteger pageIndex;//图片的索引
@property (nonatomic,strong) NSTimer *timer;//定时器
@property (nonatomic,strong) totalBlock indexBlock;//返回图片在数组中的索引
@end
