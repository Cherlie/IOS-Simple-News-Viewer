//
//  ViewController.m
//  HelloPhone
//
//  Created by WangCherlies on 15-8-16.
//  Copyright (c) 2015年 WangCherlies. All rights reserved.
//

#import "ViewController.h"
#import "NewsViewController.h"
#import "LoadingMoreView.h"

@interface ViewController ()

@end

@implementation ViewController
{
    NSOperationQueue* thumbQueue;
}

static NSInteger pageNo = 1;

//base webapi
- (NSString*)getNesAPI:(NSInteger)pageIndex
{
    NSString* _pageIndex = [NSString stringWithFormat:@"%ld",(long)pageIndex];
    return [NSString stringWithFormat:@"http://qingbin.sinaapp.com/api/lists?ntype=%%E5%%9B%%BE%%E7%%89%%87&pageNo=%@&pagePer=10&list.htm",_pageIndex];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //to solve the problem that the top cell of tableview be hiden when go back
        //main view
        if([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    thumbQueue = [[NSOperationQueue alloc]init];
    self.dataSource = [[NSMutableArray alloc]init];
    [self initFooterView];
    self.title = @"新闻阅读器";
    
    [self setupViews];
}

//Initilize footer view with activity indicator view
- (void)initFooterView{
    self.footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.tag = 10;
    indicator.frame = CGRectMake(150, 5, 15, 15);
    indicator.hidesWhenStopped = YES;
    [self.footerView addSubview:indicator];
    indicator = nil;
}

//define footer view when you roll view to bottom.
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    BOOL endOfTable = (scrollView.contentOffset.y >= (self.dataSource.count*80 - scrollView.frame.size.height));
    //load more data when end of table
    if(endOfTable && !scrollView.isDragging && !scrollView.isDecelerating){
        self.table.tableFooterView = self.footerView;
        [(UIActivityIndicatorView*)[self.footerView viewWithTag:10]startAnimating];
        [self loadMore];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [self loadDataSource];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //initilize the cell with indentifier
    UITableViewCell* cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    NSDictionary* object = [self.dataSource objectAtIndex:indexPath.row];
    NSLog(@"%@",object);
    //change style of cell's items and fill them data
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.textLabel.text = [object objectForKey:@"title"];
    cell.textLabel.numberOfLines = 0;
    cell.detailTextLabel.text = [object objectForKey:@"id"];
    cell.imageView.image = [UIImage imageNamed:@"news"];
    cell.imageView.contentMode = UIViewContentModeScaleToFill;
    
    //loading image from url async
    NSURL* url = [[NSURL alloc]initWithString:[object objectForKey:@"thumb"]];
    NSURLRequest* request = [[NSURLRequest alloc]initWithURL:url];
    //send request async
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask* downloadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error != nil){
            NSLog(@"%@",error);
        }else{
            UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
            //update ui
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.imageView.image = image;
            });
        }
    }];
    [downloadTask resume];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)setupViews
{
    //Initialize tableview
    self.table = [[UITableView alloc]initWithFrame:self.view.bounds];
    //set th delegate of tableview
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
    //regist cell of tableview
    [self.table registerClass:[UITableViewCell self] forCellReuseIdentifier:@"cell"];
    //add tableview to view
    [self.view addSubview:self.table];
}

-(void)loadMore
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        unsigned long count = [self.dataSource count];
        pageNo = (count / 10) + 1;
        [self loadDataSource];
    });
}

- (void)loadDataSource
{
    //define a request
    NSURL* nsUrl = [[NSURL alloc] initWithString:[self getNesAPI:pageNo]];
    NSURLRequest* request = [[NSURLRequest alloc]initWithURL:nsUrl];
    //get data from webapi async
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error != nil){
            //deal with http error
            NSLog(@"%@",error);
            dispatch_async(dispatch_get_main_queue(), ^{
                // error handle
            });
        }else{
            //deserialize json
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSArray* newsDataSource = [json objectForKey:@"item"];
            //run main queue to update ui
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.dataSource addObjectsFromArray:newsDataSource];
                [self.table reloadData];
            });
        }
    }];
    [dataTask resume];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //navigate to NewsViewController and set detialID
    NewsViewController* newsController = [[NewsViewController alloc]init];
    NSDictionary* object = [self.dataSource objectAtIndex:indexPath.row];
    int newsId = [[object objectForKey:@"id"]intValue];
    newsController.detialID = newsId;
    //the navigation type is push
    [self.navigationController pushViewController:newsController animated:true];
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
