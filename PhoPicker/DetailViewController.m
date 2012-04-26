//
//  DetailViewController.m
//  PhoPicker
//
//  Created by 백 승필 on 12. 4. 25..
//  Copyright (c) 2012 NHN Corp. All rights reserved.
//

#import "DetailViewController.h"
#import "AppUtility.h"
#import "UIConstants.h"
#define detailTextHeight 70
@interface DetailViewController()
- (void) makePhotoView;
- (void) makeMainView;
@end
@implementation DetailViewController

- (id) initWithDataModel:(PhotoAPIParserModel*) dataModel {
    self = [super init];
    if (self) {
        _dataModel = [dataModel retain];
    }
    return self;
}

- (void)dealloc {
    [_dataModel release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) makeMainView {
    _mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:_mainView];
    [_mainView release];
}

- (void)makePhotoView {
    CGSize imageSize = CGSizeMake([[_dataModel sizeWidth] floatValue], [[_dataModel sizeHeight] floatValue]);
    CGSize frameSize = imageSize;
    CGPoint framePoint = CGPointMake(50, 50);
    if (imageSize.width > 220) {
        frameSize.width = 220;
        frameSize.height = imageSize.height * frameSize.width / imageSize.width;
    } else {
        framePoint.x = ([[UIScreen mainScreen] bounds].size.width - frameSize.width) / 2;
    }
    _photoFrame = [[UIImageView alloc] initWithFrame:CGRectMake(framePoint.x, framePoint.y, frameSize.width, frameSize.height)];
    _photoFrame.backgroundColor = UICOLOR_DCDCDC;

    [_mainView addSubview:_photoFrame];
    [_photoFrame release];
    
    [_mainView setContentSize:CGSizeMake(320, _photoFrame.frame.origin.y + _photoFrame.frame.size.height + detailTextHeight)];
}

- (void) makeCloseBtn {
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setFrame:CGRectMake(280, 10, 23, 23)];
    [closeBtn setImage:[UIImage imageNamed:@"btn_close.png"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(actionClose) forControlEvents:UIControlEventTouchUpInside];
    [_mainView addSubview:closeBtn];
}

#pragma mark - View lifecycle

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}

- (void)viewWillAppear:(BOOL)animated {
    [self makeMainView];
    [self makeCloseBtn];
    [self makePhotoView];
    [AppUtility showIndicator:_photoFrame];
    [AppUtility setIndicatorStyleGray];
    [self performSelectorInBackground:@selector(loadImage) withObject:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.view = nil;
}

- (void) loadImage {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[_dataModel link]]];
    UIImage *image = [UIImage imageWithData:imageData];
    [self performSelectorOnMainThread:@selector(putImage:) withObject:image waitUntilDone:NO];
    
    [pool release];
}

- (void) putImage:(UIImage *) image {
    [_photoFrame setImage:image];
    [AppUtility hideIndicator];
}

- (void) actionClose {
    [self dismissModalViewControllerAnimated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
