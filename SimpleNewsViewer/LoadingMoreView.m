//
//  LoadingMoreView.m
//  HelloPhone
//
//  Created by WangCherlies on 15-8-16.
//  Copyright (c) 2015年 WangCherlies. All rights reserved.
//

#import "LoadingMoreView.h"

@interface LoadingMoreView ()

@property (strong,nonatomic)IBOutlet UIActivityIndicatorView* loadingView;
@property (strong,nonatomic)IBOutlet UIButton* loadingBtn;

@end

@implementation LoadingMoreView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        // Initialization code
//        self.loadingView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
//        self.loadingBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 0, 290, 30)];
//        [self.loadingBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(IBAction)btnClick
{
    self.loadingBtn.hidden = YES;
    self.loadingView.hidden = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.delegate footerViewLoadMore];
        self.loadingView.hidden = YES;
        self.loadingBtn.hidden = NO;
    });
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
