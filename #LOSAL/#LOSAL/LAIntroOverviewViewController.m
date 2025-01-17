//
//  LAIntroductionViewController.m
//  #LOSAL
//
//  Created by Jeffrey Algera on 9/3/13.
//  Copyright (c) 2013 Localism. All rights reserved.
//

#import "LAIntroOverviewViewController.h"

@interface LAIntroOverviewViewController ()

@property (nonatomic, weak) IBOutlet UIScrollView *pagingScrollView;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;

@property (nonatomic, strong) NSMutableArray *contentArray;
@property (nonatomic, strong) LALoginViewController *loginVC;

@end

@implementation LAIntroOverviewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _contentArray = [NSMutableArray array];

    CGRect scrollFrame = self.view.bounds;

    [_pageControl setCurrentPageIndicatorTintColor:[UIColor colorWithRed:0.251 green:0.78 blue:0.949 alpha:1]];
    
    // view 1 - intro image
    UIImage *introImage = [UIImage imageNamed:@"iphone-sign-in-01"];
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:introImage];
    imageView1.frame = scrollFrame;
    imageView1.contentMode = UIViewContentModeScaleAspectFit;
    [self.pagingScrollView addSubview:imageView1];
    scrollFrame.origin.x += imageView1.frame.size.width;
    
    // view 2 - intro image
    introImage = [UIImage imageNamed:@"iphone-sign-in-02"];
    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:introImage];
    imageView2.frame = scrollFrame;
    imageView2.contentMode = UIViewContentModeScaleAspectFit;
    [self.pagingScrollView addSubview:imageView2];
    scrollFrame.origin.x += imageView2.frame.size.width;
    
    UIView *v = [[UIView alloc] initWithFrame:scrollFrame];
    v.backgroundColor = [UIColor greenColor];
    self.loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
    self.loginVC.delegate = self;
    [v addSubview:self.loginVC.view];
    [self.pagingScrollView addSubview:v];
    scrollFrame.origin.x += v.frame.size.width;
    
    [self.pagingScrollView setContentSize:CGSizeMake(scrollFrame.origin.x, 1.0f)];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    [self.pageControl setCurrentPage:page];
}

#pragma mark Login delegate
- (void)wantsToCloseView
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didDismissLogin" object:nil];
    });
}

@end
