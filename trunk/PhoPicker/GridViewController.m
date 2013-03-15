//
//  GridViewController.m
//  PhoPicker
//
//  Created by 백 승필 on 12. 8. 9..
//  Copyright (c) 2012 NHN Corp. All rights reserved.
//

#import "GridViewController.h"
#import "MeHomeGridView.h"
#import "TestApi.h"
@implementation GridViewController
@synthesize data;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    TestApi *api = [[TestApi alloc] init];
    self.data = [api getData];
    [api release];
    gridView = [[MeHomeGridView alloc] initWithFrame:self.view.frame withTileData:self.data];
    [self.view addSubview:gridView];
    [gridView release];
    
    [self makeCloseBtn];
}

- (void) makeCloseBtn {
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setFrame:CGRectMake(280, 10, 23, 23)];
    [closeBtn setImage:[UIImage imageNamed:@"btn_close.png"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(actionClose) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
}


- (void) actionClose {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) releaseViewPage {
    for (UIView *v in [self.view subviews]) {
        [v removeFromSuperview];
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    [self releaseViewPage];
    self.view = nil;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
