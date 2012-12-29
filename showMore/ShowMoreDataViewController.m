//
//  ShowMoreDataViewController.m
//  showMore
//
//  Created by av on 29.12.12.
//  Copyright (c) 2012 av. All rights reserved.
//

#import "ShowMoreDataViewController.h"

@interface ShowMoreDataViewController ()

@property (nonatomic) BOOL isRefreshing;
@property (nonatomic, strong) NSArray *data;

@end

@implementation ShowMoreDataViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isRefreshing = NO;
    self.data = [NSArray arrayWithObjects:@"1", @"2", @"3", @"4",@"5", @"6",@"7", @"8",@"9",
                 @"10",@"11", @"12",@"13", @"14",@"15", @"16",@"17", @"18", @"19", @"20", nil];
    
    [self subscribeForKVO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - privat API

- (void)subscribeForKVO {
    
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:0 context:nil];
}

- (void)unsubscribeFromKVO {
    
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)initTableFooterView {
    
    self.downloadActivityView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.downloadActivityView.contentView.backgroundColor = [UIColor lightGrayColor];
    self.tableView.tableFooterView = self.downloadActivityView;
    self.tableView.tableFooterView.hidden = YES;
}

- (void)hideTableFooterView {
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y - self.tableView.tableFooterView.frame.size.height)];
    } completion:^(BOOL finished) {
        self.tableView.tableFooterView.hidden = YES;
        self.isRefreshing = NO;
    }];
}

#pragma mark - KVO API

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == self.tableView && [keyPath isEqualToString:@"contentOffset"]) {
        if (self.tableView.contentOffset.y >= self.tableView.contentSize.height - self.tableView.frame.size.height + [self.tableView rowHeight] * 2) {
            NSLog(@"%f", self.tableView.contentSize.height);
            if (!self.isRefreshing) {
                
                [self initTableFooterView];
                self.isRefreshing = YES;
                self.tableView.tableFooterView.hidden = NO;
                
                // Change code below with code for new data fetching / dwonloading
                
                int64_t delayInSeconds = 2.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {

                    [self hideTableFooterView];
                });
            }
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    cell.textLabel.text = [self.data objectAtIndex:[indexPath row]];
    
    return cell;
}

@end
