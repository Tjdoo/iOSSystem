//
//  MainVC.m
//  UITableView
//
//  Created by CYKJ on 2019/10/25.
//  Copyright © 2019年 D. All rights reserved.
//

#import "MainVC.h"

@interface MainVC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView * tableView;
@property (nonatomic, copy) NSArray * dataArray;

@end


@implementation MainVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
}


#pragma mark - UITableViewDelegate/DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    
    cell.textLabel.text = self.dataArray[indexPath.row][@"title"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:self.dataArray[indexPath.row][@"vcSBID"]];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - GET

- (NSArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = @[ @{ @"title" : @"1. 层级列表", @"vcSBID" : @"TreeTableVC_SBID" } ];
    }
    return _dataArray;
}

@end
