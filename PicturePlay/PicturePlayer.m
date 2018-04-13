//
//  PicturePlayer.m
//  PicturePlay
//
//  Created by suge on 16/7/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PicturePlayer.h"

@implementation PicturePlayer

-(instancetype)initWithFrame:(CGRect)frame andImageArray:(NSArray *)imageArray
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        _scrollView.backgroundColor = [UIColor whiteColor];
       
        for (NSInteger i = 0; i < 3; i ++)
        {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, 260)];

            imageView.tag = i+1;
            imageView.userInteractionEnabled = YES;
            [_scrollView addSubview:imageView];
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
            [imageView addGestureRecognizer:tapGesture];
            
        }
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, 0);
        _scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
        _scrollView.delegate  = self;
        //设置scrollView上的内容
        
        self.imageNameArray = imageArray;
        [self addSubview:_scrollView];
        [self setContentInScrollView:_scrollView];
        
        // pageControl
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _scrollView.frame.size.height - 30, _scrollView.frame.size.width / 2, 30)];
        self.pageControl.center = CGPointMake(_scrollView.frame.size.width / 2.0, _scrollView.frame.size.height - 30);
        self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        
        
        [self addSubview:self.pageControl];
        self.pageControl.numberOfPages = self.imageNameArray.count;
        
        [self addTimer];
    }
    return self;
}
#pragma mark - 开启定时器
- (void)addTimer
{
    if (_timer == nil)
    {
        _timer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(autoScroll:) userInfo:_scrollView repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}
#pragma mark - 定时器绑定的方法
- (void)autoScroll:(NSTimer *)timer
{
    [_timer.userInfo setContentOffset:CGPointMake(self.frame.size.width * 2, 0) animated:YES];
}
#pragma mark - 设置scrollView上的图片
- (void)setContentInScrollView:(UIScrollView *)scrollView
{
    UIImageView *imageView = [scrollView viewWithTag:1];
    NSString *imageNameString = _imageNameArray[_pageIndex - 1 < 0 ? _imageNameArray.count - 1 : _pageIndex - 1];
    if ([self isUrlString:imageNameString]) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageNameString]];
    }else{
        imageView.image = [UIImage imageNamed:imageNameString];
    }
    
    
    
    imageView = [scrollView viewWithTag:2];
    imageNameString = _imageNameArray[_pageIndex];
    if ([self isUrlString:imageNameString]) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageNameString]];
    }else{
        imageView.image = [UIImage imageNamed:imageNameString];
    }
    
    
    
    imageView = [scrollView viewWithTag:3];
    imageNameString = _imageNameArray[_pageIndex + 1 == _imageNameArray.count ? 0 : _pageIndex + 1];
    if ([self isUrlString:imageNameString]) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageNameString]];
    }else{
        imageView.image = [UIImage imageNamed:imageNameString];
    }
}
#pragma mark - 返回所点击图片在数组中的索引
- (void)tapGesture:(UITapGestureRecognizer *)gesture
{
    if (_indexBlock)
    {
        _indexBlock(_pageIndex);
    }
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isMemberOfClass:[UIScrollView class]])
    {
        if (scrollView.contentOffset.x == self.frame.size.width * 2)
        {
            scrollView.contentOffset = CGPointMake(self.frame.size.width * 1, 0);
            _pageIndex++;
            if (_pageIndex == _imageNameArray.count)
            {
                _pageIndex = 0;
            }
            [self setContentInScrollView:scrollView];
            
        }else if (scrollView.contentOffset.x == 0)
        {
            scrollView.contentOffset = CGPointMake(self.frame.size.width * 1, 0);
            _pageIndex--;
            if (_pageIndex == -1)
            {
                _pageIndex = _imageNameArray.count - 1;
            }
            [self setContentInScrollView:scrollView];
        }
        self.pageControl.currentPage = _pageIndex;
    }
}
#pragma mark - 带动画的滑动结束后才会调用(手滑动的时候不会调用该方法)
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if ([scrollView isMemberOfClass:[UIScrollView class]])
    {
        if (scrollView.contentOffset.x == self.frame.size.width * 2)
        {
            scrollView.contentOffset = CGPointMake(self.frame.size.width * 1, 0);
            _pageIndex++;
            if (_pageIndex == _imageNameArray.count)
            {
                _pageIndex = 0;
            }
            [self setContentInScrollView:scrollView];
            
        }else if (scrollView.contentOffset.x == 0)
        {
            scrollView.contentOffset = CGPointMake(self.frame.size.width * 1, 0);
            _pageIndex--;
            if (_pageIndex == -1)
            {
                _pageIndex = _imageNameArray.count - 1;
            }
            [self setContentInScrollView:scrollView];
        }
        self.pageControl.currentPage = _pageIndex;
    }
}
#pragma mark - scrollView将要开始拖动的时候
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([scrollView isMemberOfClass:[UIScrollView class]])
    {
        [_timer invalidate]; //销毁定时器
        _timer = nil;
    }
}
#pragma mark - 手滑动的时候，不会调用上面方法。为了避免闪一下。（手滑动的时候会调用下面这个方法啊），所以我把上面代码再在这写一遍。
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
}
#pragma mark - 正则匹配URL
- (BOOL)isUrlString:(NSString *)str{
    NSString *pattern = @"\\b(([\\w-]+://?|www[.])[^\\s()<>]+(?:\\([\\w\\d]+\\)|([^[:punct:]\\s]|/)))";
    NSPredicate *pred = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}
@end
