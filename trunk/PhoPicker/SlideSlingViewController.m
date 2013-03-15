//
//  SlideSlingViewController.m
//  PhoPicker
//
//  Created by 백 승필 on 12. 8. 13..
//  Copyright (c) 2012 NHN Corp. All rights reserved.
//

#import "SlideSlingViewController.h"
#import "SlideSlingView.h"
#import "SlideSlingGestureView.h"
@implementation SlideSlingViewController

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
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",@"0",@"1",@"1",@"2",@"2",@"3",@"3",@"4",@"4",@"5",@"5",@"6",@"6",@"7",@"7", nil];
    SlideSlingGestureView *slingView = [[SlideSlingGestureView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 50) withData:data];
    [self.view addSubview:slingView];
    [slingView release];
    
    [slingView moveSlideAtIndex:4];
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
    [self releaseViewPage];
    self.view = nil;
    [super viewDidUnload];
 
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
