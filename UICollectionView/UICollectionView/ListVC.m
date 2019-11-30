//
//  ListVC.m
//  UICollectionView
//
//  Created by CYKJ on 2019/11/21.
//  Copyright © 2019年 D. All rights reserved.


#import "ListVC.h"

@interface ListVC ()

@property (nonatomic, copy) NSArray * datas;

@end


@implementation ListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    
    self.datas = @[ @{ @"title" : @"1. 吸顶", @"vcSBID" : @"ViewController_SBID" },
                    @{ @"title" : @"2. 书柜", @"vcSBID" : @"BookCaseVC_SBID" },
                    @{ @"title" : @"3. 系统转场", @"vcSBID" : @"TransitionVC_SBID"} ];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = self.datas[indexPath.row][@"title"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:self.datas[indexPath.row][@"vcSBID"]];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
