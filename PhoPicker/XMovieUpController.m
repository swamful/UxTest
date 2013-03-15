//
//  XMovieUpController.m
//  PhoPicker
//
//  Created by 백 승필 on 12. 9. 19..
//  Copyright (c) 2012 NHN Corp. All rights reserved.
//

#import "XMovieUpController.h"

#import "MainView.h"
@implementation XMovieUpController
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
    mainView = [[MainView alloc] initWithFrame:CGRectMake(0, 71, 320, 420)];
    [self.view addSubview:mainView];
    self.view.layer.contents = (id) [UIImage imageNamed:@"cardback"].CGImage;
    [mainView release];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 480 - 42, 320, 42)];
    bottomView.layer.contents = (id) [UIImage imageNamed:@"cardbottom"].CGImage;
    [self.view addSubview:bottomView];
    [bottomView release];
    
    [self.navigationController setNavigationBarHidden:YES];
    [self makeCloseBtn];
}

- (void) makeCloseBtn {
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setFrame:CGRectMake(280, 10, 23, 23)];
    [closeBtn setImage:[UIImage imageNamed:@"btn_close.png"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(actioncontrollerClose) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    
    
}


- (void) actioncontrollerClose {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) go {
    [[mainView text] resignFirstResponder];
    xmovie = [[XMovieUpView alloc] initWithFrame:CGRectMake(0, 71, 320, 420)];
    xmovie.startIndex = [[[mainView text] text] intValue];
    [mainView removeFromSuperview];
    [self.view insertSubview:xmovie atIndex:0];
    [xmovie release];
}

- (void) animation {
    [UIView transitionWithView:self.view duration:1
					   options:UIViewAnimationOptionTransitionCurlUp
					animations:^{
                        [xmovie removeFromSuperview];

                        
                        mainView = [[MainView alloc] initWithFrame:CGRectMake(0, 71, 320, 420)];
                        [self.view addSubview:mainView];
                        [mainView release];
                        
                        //                        
					} completion:^(BOOL finished){
    }];
}

- (void) actionClose {
//    CABasicAnimation *hiddenAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
//    hiddenAnimation.duration = 0.01f;
//    hiddenAnimation.toValue = [NSNumber numberWithFloat:0.0f];
//    [xmovie.layer addAnimation:hiddenAnimation forKey:@"hiddenAnimation"];
//    xmovie.hidden = YES;
    [self performSelector:@selector(animation) withObject:nil afterDelay:0.00];

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
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
