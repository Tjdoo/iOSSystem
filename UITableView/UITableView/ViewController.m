//
//  ViewController.m
//  UITableView
//
//  Created by CYKJ on 2019/6/5.
//  Copyright © 2019年 D. All rights reserved.


#import "ViewController.h"
#import "ListDataSource.h"
#import "ListDataSourceCell.h"


@interface ViewController () <UITableViewDelegate>
{
    NSArray * _listData;
}
@property (weak, nonatomic) IBOutlet UITableView * tableView;
@property (nonatomic, strong) ListDataSource * dataSource;

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataSource = [[ListDataSource alloc] initWithItems:[self listData]
                                             cellIdentifier:CELL_RUID
                                             configureBlock:^(ListDataSourceCell * _Nonnull cell,
                                                              NSString * _Nonnull item,
                                                              NSIndexPath * _Nonnull indexPath) {
                                                 [cell setData:item];
                                             }];
    self.tableView.rowHeight = 80.0;
    self.tableView.dataSource = self.dataSource;
    
    // reloadData 之后滚动至指定位置。注意 runloop 的用处
//    [self.tableView reloadData];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:10 inSection:0]
//                              atScrollPosition:UITableViewScrollPositionMiddle
//                                      animated:YES];
//    });
    
    // 解决 pop 手势中断后 tableView 偏移问题
//    self.extendedLayoutIncludesOpaqueBars = YES;
}


#pragma mark - UITableViewDelegate

/**
  *  @brief   修改 footerView 颜色的方式有两种：一种是网络上找到的 UITableViewHeaderFooterView 方式；另一种是代理返回 UIView 的方式。因为 UITableViewHeaderFooterView 的界面结构比 UIView 复杂（有 contentView、backgroundView），容易出错

                        UITableViewHeaderFooterView.backgroundColor = [UIColor clearColor];
                        UITableViewHeaderFooterView.backgroundView.backgroundColor = [UIColor clearColor];
                        UITableViewHeaderFooterView.contentView.backgroundColor = [UIColor clearColor];
 
            比如同时设置三个控件为透明色，然后依然显示了颜色。推荐用 UIView，可控性高。
  */
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UITableViewHeaderFooterView * view = [[UITableViewHeaderFooterView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    // plain 模式，处理 sectionHeader、sectionFooter 的颜色。https://www.cnblogs.com/qqcc1388/p/10458185.html
    if ([view isMemberOfClass:[UITableViewHeaderFooterView class]]) {
        ((UITableViewHeaderFooterView *)view).contentView.backgroundColor = [UIColor clearColor];
    }
}


#pragma mark - GET

- (NSArray *)listData
{
    if (_listData == nil) {
        _listData = @[ @"运动", @"体重", @"血压", @"血糖", @"尿酸" ];
    }
    return _listData;
}

@end
