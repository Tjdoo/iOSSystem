//
//  NextVC.m
//  UIViewController
//
//  Created by CYKJ on 2019/8/26.
//  Copyright © 2019年 D. All rights reserved.
//

#import "NextVC.h"
#import "UIViewController+PopGesture.h"
#import "UIScrollView+PopGesture.h"


@interface NextVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UITableView * tableView;
@end


@implementation NextVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 禁用本页面的侧滑返回手势
    //self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    self.tableView.rowHeight  = 45.0;
    [self.tableView addObserver:self
                     forKeyPath:@"contentOffset"
                        options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                        context:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //    [UIViewController popGestureClose:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //    [UIViewController popGestureOpen:self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"%@ = %@", change[NSKeyValueChangeOldKey], change[NSKeyValueChangeNewKey]);
}


#pragma mark - UITableViewDelegate/DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"CELL"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView * bgView = [[UIView alloc] initWithFrame:self.view.window.bounds];
    bgView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                         action:@selector(taped:)]];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    view.backgroundColor = [UIColor redColor];
    [bgView addSubview:view];
    
    [self.view.window addSubview:bgView];
    
    [UIApplication sharedApplication].statusBarHidden = YES;
}


#pragma mark - Touch

- (void)taped:(UITapGestureRecognizer *)gesture
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    [gesture.view removeFromSuperview];
}

@end
