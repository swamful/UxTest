//
//  SlideShowController.m
//  PhoPicker
//
//  Created by 백 승필 on 12. 8. 7..
//

#import "SlideShowController.h"
#define menuBarHeight 40
@interface SlideShowController()
- (void) makeMenuBar;
- (void) makeCloseBtn;
@end

@implementation SlideShowController

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
    [UIApplication sharedApplication].idleTimerDisabled = YES; 
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    showView = [[SlideShowView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:showView];
    [showView release];
    

    [self makeMenuBar];
        
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapRecognizer];
    [tapRecognizer release];
}

- (void) makeMenuBar {
    _pannelView = [[UIView alloc] initWithFrame:CGRectMake(0, -menuBarHeight, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height + 2 * menuBarHeight)];
    _pannelView.userInteractionEnabled = YES;
    [self.view addSubview:_pannelView];
    [_pannelView release];
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] applicationFrame].size.width, menuBarHeight)];
    _topView.backgroundColor = [UIColor blackColor];
    _topView.userInteractionEnabled = YES;
    _topView.alpha = 0.3;
    [_pannelView addSubview:_topView];
    [_topView release];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, _pannelView.frame.size.height - menuBarHeight, [[UIScreen mainScreen] applicationFrame].size.width, menuBarHeight)];
    _bottomView.backgroundColor = [UIColor blackColor];
    _bottomView.alpha = 0.3;
    [_pannelView addSubview:_bottomView];
    [_bottomView release];
    
    [self makeCloseBtn];
}

- (void) makeCloseBtn {
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeBtn setFrame:CGRectMake(280, 10, 23, 23)];
    [_closeBtn setImage:[UIImage imageNamed:@"btn_close.png"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(actionSlideViewClose) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_closeBtn];
}

- (void) animationPlay {
    [UIView animateWithDuration:0.3 animations:^(){
        if (_pannelView.frame.origin.y == 0) {
            _pannelView.frame = CGRectMake(0, -menuBarHeight, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height + 2 * menuBarHeight);
        } else {
            _pannelView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        }
        _bottomView.frame = CGRectMake(0, _pannelView.frame.size.height - menuBarHeight, [[UIScreen mainScreen] applicationFrame].size.width, menuBarHeight);
    }];
}

- (void) actionSlideViewClose {
    [UIApplication sharedApplication].idleTimerDisabled = NO; 
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) slideStart {
    [showView triggerSlideAnimation];
}
- (void) slideStop {
    [showView stopAnimation];
}

- (void)handleTap:(UITapGestureRecognizer*)recognizer
{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)recognizer;
    CGPoint location = [tap locationInView:tap.view];
    if (CGRectContainsPoint(_closeBtn.frame, location)) {
        [self actionSlideViewClose];
        return;
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        [self animationPlay];
    }
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
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
