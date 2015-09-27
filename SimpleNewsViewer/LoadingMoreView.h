//
//  LoadingMoreView.h
//  HelloPhone
//
//  Created by WangCherlies on 15-8-16.
//  Copyright (c) 2015年 WangCherlies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingMoreDelegate.h"

@interface LoadingMoreView : UIView

@property (strong,nonatomic)id<LoadingMoreDelegate> delegate;

@end
