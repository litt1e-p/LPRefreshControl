//
//  TableViewController.m
//  LPRefreshControl
//
//  Created by litt1e-p on 16/1/9.
//  Copyright © 2016年 litt1e-p. All rights reserved.
//

#import "TableViewController.h"
#import "LPRefreshControl.h"

@interface TableViewController ()

@property (nonatomic, strong) NSMutableArray *rows;

@end

@implementation TableViewController

static NSString *const kCellID = @"kCellID";

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"LPRefreshControl";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initialRefreshControl];
}

- (void)initialRefreshControl
{
    __weak typeof(self) weakSelf = self;
    [[LPRefreshControl sharedInstance] addRefreshInView:self.tableView withTopHandler:^{
        [weakSelf insertRowAtTop];
    } andBottomHandler:^{
        [weakSelf insertRowAtBottom];
    }];
    [[LPRefreshControl sharedInstance] triggerRefreshInView:self.tableView atPosition:RefreshPositionTop];
}

- (void)insertRowAtTop
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.rows insertObject:[NSString stringWithFormat:@"Row+++%lu", (unsigned long)self.rows.count] atIndex:0];
        [self.tableView beginUpdates];
        NSArray *insertIndexPaths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil];
        [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
        [[LPRefreshControl sharedInstance] stopAnimatingInView:self.tableView atPosition:RefreshPositionTop];
    });
}

- (void)insertRowAtBottom
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.rows addObject:[NSString stringWithFormat:@"Row+++%lu", (unsigned long)self.rows.count]];
        [self.tableView beginUpdates];
        NSArray *insertIndexPaths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:self.rows.count - 1 inSection:0], nil];
        [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
        [[LPRefreshControl sharedInstance] stopAnimatingInView:self.tableView atPosition:RefreshPositionBottom];
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rows.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID forIndexPath:indexPath];
    cell.textLabel.text = self.rows[indexPath.row];
    return cell;
}

#pragma mark - lazy loads 📌
- (NSMutableArray *)rows
{
    if (!_rows) {
        NSMutableArray *tempArr = [NSMutableArray array];
        for (int i = 0; i < 20; i++) {
            [tempArr addObject:[NSString stringWithFormat:@"Row---%d", i]];
        }
        self.rows = tempArr;
    }
    return _rows;
}

@end
