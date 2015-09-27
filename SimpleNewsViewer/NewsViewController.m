//
//  NewsViewController.m
//  HelloPhone
//
//  Created by WangCherlies on 15-8-16.
//  Copyright (c) 2015年 WangCherlies. All rights reserved.
//

#import "NewsViewController.h"

@interface NewsViewController ()

@end

@implementation NewsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.webView = [[UIWebView alloc]initWithFrame:self.view.frame];
    self.webView.delegate = self;
    self.title = @"新闻中心";
    [self.view addSubview:self.webView];
    
    self.spinner = [[UIActivityIndicatorView alloc]initWithFrame:CGRectZero];
    self.spinner.center = self.view.center;
    [self.view addSubview:self.spinner];
    [self loadData];
}

- (void)loadData{
    NSString* const urlStr = [NSString stringWithFormat:@"http://qingbin.sinaapp.com/api/html/%ld.html",(long)self.detialID];
    NSLog(@"%@",urlStr);
    NSURL* url = [[NSURL alloc]initWithString:urlStr];
    NSURLRequest* urlRequest = [[NSURLRequest alloc]initWithURL:url];
    [self.webView loadRequest:urlRequest];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self.spinner startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.spinner stopAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
