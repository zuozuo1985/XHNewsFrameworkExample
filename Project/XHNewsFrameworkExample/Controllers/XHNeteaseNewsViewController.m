//
//  XHNeteaseNewsViewController.m
//  XHNewsFrameworkExample
//
//  Created by 曾 宪华 on 14-1-24.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHNeteaseNewsViewController.h"
#import <XHNewsFramework/XHMenu.h>
#import <XHNewsFramework/XHNewsDetail.h>
#import <XHNewsFramework/XHScrollBannerView.h>

#import "XHNetNewsCell.h"
#import "HUAJIEBannerView.h"

#import "XHDataStoreManager.h"

@interface XHNeteaseNewsViewController () <XHContentViewRefreshingDelegate>

@property (nonatomic, strong) NSMutableArray *bannerViews;
@property (nonatomic, strong) XHScrollBannerView *scrollBannerView;

@end

@implementation XHNeteaseNewsViewController

#pragma mark - Action

- (void)rightOpened {
    [self.sideMenuViewController presentRightViewController];
}

- (void)leftOpened {
    [self.sideMenuViewController presentMenuViewController];
}

- (void)receiveScrollViewPanGestureRecognizerHandle:(UIPanGestureRecognizer *)scrollViewPanGestureRecognizer {
    [self.sideMenuViewController panGestureRecognized:scrollViewPanGestureRecognizer];
}

#pragma mark - Perprotys

- (NSMutableArray *)bannerViews {
    if (!_bannerViews) {
        _bannerViews = [[NSMutableArray alloc] init];
        [_bannerViews addObject:[[HUAJIEBannerView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.scrollBannerView.bounds), CGRectGetHeight(self.scrollBannerView.bounds))]];
        [_bannerViews addObject:[[HUAJIEBannerView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.scrollBannerView.bounds), CGRectGetHeight(self.scrollBannerView.bounds))]];
        [_bannerViews addObject:[[HUAJIEBannerView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.scrollBannerView.bounds), CGRectGetHeight(self.scrollBannerView.bounds))]];
        [_bannerViews addObject:[[HUAJIEBannerView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.scrollBannerView.bounds), CGRectGetHeight(self.scrollBannerView.bounds))]];
        [_bannerViews addObject:[[HUAJIEBannerView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.scrollBannerView.bounds), CGRectGetHeight(self.scrollBannerView.bounds))]];
        [_bannerViews addObject:[[HUAJIEBannerView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.scrollBannerView.bounds), CGRectGetHeight(self.scrollBannerView.bounds))]];
    }
    return _bannerViews;
}

- (XHScrollBannerView *)scrollBannerView {
    if (!_scrollBannerView) {
        __weak typeof(self) weakSelf = self;
        _scrollBannerView = [[XHScrollBannerView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 200) animationDuration:3.0f];
        self.scrollBannerView.totalPagesCount = ^NSUInteger(void){
            return weakSelf.bannerViews.count;
        };
        self.scrollBannerView.fetchContentViewAtIndex = ^UIView *(NSUInteger pageIndex){
            return weakSelf.bannerViews[pageIndex];
        };
        self.scrollBannerView.fetchFocusTitle = ^NSString *(NSUInteger pageIndex) {
            if (pageIndex == 0) {
                return @"我是皇上，你想怎样？";
            } else if (pageIndex == 1) {
                return @"我是王子，那你又想怎样？";
            } else if (pageIndex == 2) {
                return @"我是Jack，那你还想怎样？";
            } else {
                return @"我管你是谁，我就是仿网易新闻";
            }
        };
        _scrollBannerView.didSelectCompled = ^(NSUInteger selectIndex) {
            NSLog(@"selectIndex : %d", selectIndex);
        };
    }
    return _scrollBannerView;
}
#pragma mark - Life cycle

- (id)init {
    self = [super init];
	if (self) {
        self.isShowTopScrollToolBar = YES;
        // custom UI
        /*
         self.topScrollViewToolBarBackgroundColor = [UIColor colorWithRed:0.362 green:0.555 blue:0.902 alpha:1.000];
         self.leftShadowImage = [UIImage imageNamed:@"leftShadow"];
         self.rightShadowImage = [UIImage imageNamed:@"rightShadow"];
         self.indicatorColor = [UIColor colorWithRed:0.219 green:0.752 blue:0.002 alpha:1.000];
         self.managerButtonBackgroundImage = [UIImage imageNamed:@"managerMenuButton"];
         
         self.midContentLogoImage = [UIImage imageNamed:@"logo"];
         self.contentScrollViewBackgroundColor = [UIColor colorWithRed:1.000 green:0.724 blue:0.640 alpha:1.000];
         */
    }
	return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)loadNetWorkDataSource:(void (^)())compled {
    __weak typeof(self) weakSelf = self;
    [[XHDataStoreManager shareDataStoreManager] loadNetDataSourceWithPagesize:100 pageNumber:1 compledBlock:^(NSMutableArray *datas) {
        
        NSMutableArray *items = [NSMutableArray array];
        for (NSInteger i = 0; i < 10; i ++) {
            XHMenu *item = [[XHMenu alloc] init];
            NSString *title = @"头条";
            item.title = title;
            item.titleNormalColor = [UIColor colorWithWhite:0.141 alpha:1.000];
            item.titleFont = [UIFont boldSystemFontOfSize:16];
            
            item.dataSources = [NSMutableArray arrayWithArray:datas];
            
            [items addObject:item];
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.items = items;
            [weakSelf reloadDataSource];
            if (compled) {
                compled();
            }
        });
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)])
        [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)])
        self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"网易新闻";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Left" style:UIBarButtonItemStyleBordered target:self action:@selector(leftOpened)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Right" style:UIBarButtonItemStyleBordered target:self action:@selector(rightOpened)];
    
    [self loadNetWorkDataSource:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - contentView refreshControl delegate

- (void)pullDownRefreshingAction:(XHContentView *)contentView {
    [self loadNetWorkDataSource:^{
        [contentView endPullDownRefreshing];
    }];
}

- (void)pullUpRefreshingAction:(XHContentView *)contentView {
    [contentView performSelector:@selector(endPullUpRefreshing) withObject:nil afterDelay:3];
}

#pragma mark contentViews delegate/datasource

- (NSInteger)numberOfContentViews {
	int numberOfPanels = [self.items count];
	return numberOfPanels;
}

- (NSInteger)contentView:(XHContentView *)contentView numberOfRowsInPage:(NSInteger)page section:(NSInteger)section {
    XHMenu *item = [self.items objectAtIndex:page];
	return [item.dataSources count];
}

- (UITableViewCell *)contentView:(XHContentView *)contentView cellForRowAtIndexPath:(XHPageIndexPath *)indexPath {
	static NSString *cellIdentifier = @"cellIdentifier";
	XHNetNewsCell *cell = [contentView.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[XHNetNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    XHMenu *menu = [self.items lastObject];
    XHNewsModel *newsModel = [menu.dataSources objectAtIndex:indexPath.row];
    
    cell.newsModel = newsModel;
    
    
	return cell;
}

- (void)contentView:(XHContentView *)contentView didSelectRowAtIndexPath:(XHPageIndexPath *)indexPath {
	NSLog(@"row : %d section : %d  page : %d", indexPath.row, indexPath.section, indexPath.page);
    [super contentView:contentView didSelectRowAtIndexPath:indexPath];
}

- (XHContentView *)contentViewForPage:(NSInteger)page {
	static NSString *identifier = @"XHContentView";
	XHContentView *contentView = (XHContentView *)[self dequeueReusablePageWithIdentifier:identifier];
	if (contentView == nil) {
		contentView = [[XHContentView alloc] initWithIdentifier:identifier];
        contentView.pullDownRefreshed = YES;
        contentView.refreshControlDelegate = self;
	}
    if (!page)
        contentView.tableView.tableHeaderView = self.scrollBannerView;
    else
        contentView.tableView.tableHeaderView = nil;
	return contentView;
}

#pragma mark - UITableView delegate

- (CGFloat)contentView:(XHContentView *)contentView heightForRowAtIndexPath:(XHPageIndexPath *)indexPath {
    return 100;
}

@end
