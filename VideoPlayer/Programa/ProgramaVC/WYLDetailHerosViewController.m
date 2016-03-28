//
//  WYLDetailHerosViewController.m
//  VideoPlayer
//
//  Created by Snake on 16/3/25.
//  Copyright © 2016年 Snake. All rights reserved.
//

#import "WYLDetailHerosViewController.h"

@interface WYLDetailHerosViewController ()

@end

@implementation WYLDetailHerosViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    UIWebView *detailView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    detailView.scalesPageToFit = YES;
    [self.view addSubview:detailView];
    NSURL *url = [NSURL URLWithString:self.sourceURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [detailView loadRequest:request];
}
@end
