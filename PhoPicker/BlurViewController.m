//
//  BlurViewController.m
//  PhoPicker
//
//  Created by 승필 백 on 13. 3. 6..
//

#import "BlurViewController.h"
#import "BlurView.h"
@interface BlurViewController ()

@end

@implementation BlurViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    BlurView *blurView = [[BlurView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:blurView];
    [blurView release];
    
    [self.navigationController setNavigationBarHidden:YES];
    [self makeCloseBtn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) makeCloseBtn {
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setFrame:CGRectMake(280, 10, 23, 23)];
    [closeBtn setImage:[UIImage imageNamed:@"btn_close.png"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(actioncontrollerClose) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    
    
}


- (void) actioncontrollerClose {
    NSLog(@"action close");
    [self.navigationController popViewControllerAnimated:YES];
}

@end
