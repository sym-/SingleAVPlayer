//
//  ViewController.m
//  SingleAVPlayer
//
//  Created by 宋元明 on 16/5/27.
//  Copyright © 2016年 宋元明. All rights reserved.
//

#import "ViewController.h"
#import "YMTableViewCell.h"
#import "AFNetworking.h"
#import "YMVideoModel.h"
#import "YMAVPlayerManager.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

static NSString *const videoListUrl = @"http://c.3g.163.com/nc/video/list/VAP4BFR16/y/0-10.html";

static NSString *const cellIdentifier = @"YMCELL";

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (strong ,nonatomic) NSMutableArray *sourceArr;

@end

@implementation ViewController

-(NSMutableArray *)sourceArr{
    if (!_sourceArr) {
        _sourceArr = [NSMutableArray array];
    }
    
    return _sourceArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self getData];
    [self.tableview registerNib:[UINib nibWithNibName:NSStringFromClass([YMTableViewCell class]) bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.rowHeight = kScreenWidth * 9 / 16.0;
}

-(void)getData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:videoListUrl parameters:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
              [self.sourceArr removeAllObjects];
              NSArray *dataArray = responseObject[@"VAP4BFR16"];
              
//              NSData *data = [NSJSONSerialization dataWithJSONObject:dataArray options:NSJSONWritingPrettyPrinted error:nil];
//              NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
              
              [dataArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
                  YMVideoModel *model = [[YMVideoModel alloc] init];
                  [model autoParseDictionary:dict];
                  [self.sourceArr addObject:model];
              }];
              
              [self.tableview reloadData];
              
    }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    __weak YMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.model = self.sourceArr[indexPath.row];
    
    __weak typeof(self) weakSelf = self;
    cell.playOrPause = ^(YMVideoModel *model){
        YMAVPlayerManager *manager = [YMAVPlayerManager sharedInstance];
        if ([manager videoPlayerViewExisted]) {
            [manager destroyPlayerView];
        }
        manager.url = model.mp4_url;
        [manager showVideoPlayerViewInView:cell.contentView frame:cell.bgImage.frame];
    };
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

@end
