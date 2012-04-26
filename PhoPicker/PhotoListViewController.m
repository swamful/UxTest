//
//  PhotoListViewController.m
//  PhoPicker
//
//  Created by 백 승필 on 12. 4. 12..
//  Copyright (c) 2012 NHN Corp. All rights reserved.
//

#import "PhotoListViewController.h"
#import "PhotoAPIModel.h"
#import "PhotoFrameButtonView.h"
#import "TitleView.h"
#import "DetailViewController.h"
@interface PhotoListViewController()
- (void) createViewPage;
- (void) releaseViewPage;
- (void) makeTitleView;
@end

@implementation PhotoListViewController
@synthesize searchText = _searchText, searchEngine;
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (id) initWithType:(PhotoListType) type {
    self = [super init];
    if (self) {
        photoListType = type;
    }
    return self;
}

- (void) dealloc {
    [_searchText release];
    [_photoList release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createViewPage];
    [[PhotoAPIModel getSharedInstance] setDelegate:self];
    if (!_photoList) {
        _photoList = [[NSMutableArray alloc] init];
    } 
    
    switch (photoListType) {
        case PHOTO_LIST_BY_SEARCH:
            [_photoList removeAllObjects];
            [[PhotoAPIModel getSharedInstance] getPhotoListBySearchText:_searchText withEngine:searchEngine];
            break;
        case PHOTO_LIST_BY_CURRENT:
            [[PhotoAPIModel getSharedInstance] getCurrentPhotoList];
            break;
            
        default:
            break;
    }
}

- (void) createViewPage {
    _photoListView = [[PhotoListView alloc] initWithFrame:CGRectMake(2, navigationTitleBarHeight, 315, 460)];
    _photoListView.delegate = self;
//    _photoListView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_photoListView];
    [_photoListView release];
    
    [self makeTitleView];
}

- (void) makeTitleView {
    self.navigationController.navigationBarHidden = YES;
    TitleView *titleView = [[TitleView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, navigationTitleBarHeight)];
    switch (photoListType) {
        case PHOTO_LIST_BY_SEARCH:
            [titleView setTitle:[NSString stringWithFormat:@"%@", _searchText]];
            break;
        case PHOTO_LIST_BY_CURRENT:
            [titleView setTitle:@"최신 이미지"];
            break;
        default:
            break;
    }

    [self.view addSubview:titleView];
    [titleView setLeftBtnSelector:@selector(actionBack)];
    [titleView release];
}

- (void) actionBack {
    [[PhotoAPIModel getSharedInstance] cancelRequest];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) releaseViewPage {
    for (UIView *v in [self.view subviews]) {
        [v removeFromSuperview];
    }
}

- (void) viewWillAppear:(BOOL)animated {

    
}

- (void) viewWillDisappear:(BOOL)animated {

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self releaseViewPage];
    self.view = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) getLargePhoto:(id) control {
    PhotoFrameButtonView *frameBtn = (PhotoFrameButtonView*)control;
    
    DetailViewController *detailViewController = [[DetailViewController alloc] initWithDataModel:[_photoList objectAtIndex:frameBtn.index]];
    [self presentModalViewController:detailViewController animated:NO];
    [detailViewController release];
    
}

#pragma mark - PhotoAPIModel Delegate
- (void) requestDone:(PhotoAPIParserModel*) resultData {
    switch (photoListType) {
        case PHOTO_LIST_BY_SEARCH:
            [resultData setTagText:_searchText];
            break;
        case PHOTO_LIST_BY_CURRENT:
            [resultData setTagText:@"hot issue"];
            break;
        default:
            break;
    }
    [resultData setIndex:[_photoList count]];
    [_photoListView setImageData:resultData];
    [_photoList addObject:resultData];
}

- (void) apiRequestError:(NSError *) error {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
    switch ([error code]) {
        case -1001:
            alertView.message = [NSString stringWithFormat:@"%@ \ncode=%@",kNetworkErrorAlertMessage, [error code]];
            break;            
        default:
            alertView.message = [NSString stringWithFormat:@"%@ \ncode=%@",kDefaultErrorAlertMessage, [error code]];
            break;
    }
    [alertView show];
    [alertView release];
}

#pragma scrollview delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"photocount : %d", [_photoList count]);
    NSLog(@"scrollViewWillBeginDragging");
}
@end
