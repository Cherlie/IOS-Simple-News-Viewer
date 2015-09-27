//
//  NewsViewController.h
//  HelloPhone
//
//  Created by WangCherlies on 15-8-16.
//  Copyright (c) 2015年 WangCherlies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsViewController : UIViewController<UIWebViewDelegate>

@property NSInteger detialID;
@property (strong,nonatomic)UIWebView* webView;
@property (strong,nonatomic)UIActivityIndicatorView* spinner;

@end
