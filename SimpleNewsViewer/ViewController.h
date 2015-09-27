//
//  ViewController.h
//  HelloPhone
//
//  Created by WangCherlies on 15-8-16.
//  Copyright (c) 2015年 WangCherlies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic)UITableView* table;
@property (strong,nonatomic)NSMutableArray* dataSource;

@property (strong,nonatomic)UIView * footerView;

@end
