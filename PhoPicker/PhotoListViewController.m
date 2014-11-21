//
//  PhotoListViewController.m
//  PhoPicker
//
//  Created by 백 승필 on 12. 4. 12..
//

#import "PhotoListViewController.h"
#import "PhotoAPIModel.h"
#import "PhotoFrameButtonView.h"

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
        dqueue = dispatch_queue_create("getImage", NULL);
    }
    return self;
}

- (void) dealloc {
    dispatch_release(dqueue);
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
    downLoadCount = 0;
    switch (photoListType) {
        case PHOTO_LIST_BY_SEARCH:
            [_photoList removeAllObjects];
            _isRequestingQuery = YES;
            [[PhotoAPIModel getSharedInstance] getPhotoListBySearchText:_searchText withEngine:searchEngine startIndex:1];
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
    _photoListView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_photoListView];
    [_photoListView release];
    
    [self makeTitleView];
}

- (void) makeTitleView {
    self.navigationController.navigationBarHidden = YES;
    titleView = [[TitleView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, navigationTitleBarHeight)];
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

- (void) actionDetailViewClose {
    _photoListView.layer.opacity = 1.0f;
    titleView.layer.opacity = 1.0f;
    [infoView removeFromSuperview];
    infoView = nil;
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

- (void) moveDetailedPage:(PhotoAPIParserModel *) dataModel {
    infoView.hidden = NO;
    [layer removeFromSuperlayer];
    layer = nil;
}

- (void) putImage:(UIImage *) image {
    if (infoView) {
        [infoView putImage:image];        
    }
}

- (void)fadeIt {
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	animation.toValue = [NSNumber numberWithFloat:0.0];
	animation.fromValue = [NSNumber numberWithFloat:layer.opacity];
	animation.duration = 0.7;
	_photoListView.layer.opacity = 0.0; // This is required to update the model's value.  Comment out to see what happens.
    titleView.layer.opacity = 0.0;
	[_photoListView.layer addAnimation:animation forKey:@"animateOpacity"];
	[titleView.layer addAnimation:animation forKey:@"animateOpacity"];
}

- (void) moveLayer:(PhotoAPIParserModel *) dataModel {
    CGSize imageSize = CGSizeMake([[dataModel sizeWidth] floatValue], [[dataModel sizeHeight] floatValue]);
    CGSize frameSize = imageSize;
    CGPoint framePoint = CGPointMake(50, 50);
    if (imageSize.width > 220) {
        frameSize.width = 220;
        frameSize.height = imageSize.height * frameSize.width / imageSize.width;
    } else {
        framePoint.x = ([[UIScreen mainScreen] bounds].size.width - frameSize.width) / 2;
    }
        
    [CATransaction setDisableActions:NO];
    layer.bounds = CGRectMake(0, 0, frameSize.width, frameSize.height);
    layer.position = CGPointMake(self.view.frame.size.width / 2, (frameSize.height / 2 + framePoint.y));
    [self fadeIt];
    [self performSelector:@selector(moveDetailedPage:) withObject:dataModel afterDelay:1];    
}

- (void) getLargePhoto:(id) control {
    if (layer) {
        return;
    }
    
    
    PhotoFrameButtonView *frameBtn = (PhotoFrameButtonView*)control;
    PhotoAPIParserModel *dataModel = [_photoList objectAtIndex:frameBtn.index];
    
    infoView = [[DetailInfoView alloc] initWithFrame:self.view.frame withDataModel:dataModel];
    infoView.hidden = YES;
    [self performSelectorInBackground:@selector(loadLargeImage:) withObject:[dataModel link]];
    [self.view addSubview:infoView];
    [infoView release];
    
    layer = [CALayer layer];
    layer.contents = (id)[frameBtn backgroundImageForState:UIControlStateNormal].CGImage;
    layer.position = CGPointMake(frameBtn.frame.size.width/2 + 2 + [frameBtn superview].frame.origin.x, frameBtn.frame.size.height/2 + frameBtn.frame.origin.y + navigationTitleBarHeight + 2 -_photoListView.contentOffset.y);
    layer.bounds = CGRectMake(0, 0, frameBtn.frame.size.width, frameBtn.frame.size.height);
    layer.opacity = 1.0f;
    [self.view.layer addSublayer:layer];
    
    [self performSelector:@selector(moveLayer:) withObject:dataModel afterDelay:0.1];
}

- (void) loadLargeImage:(NSString*) linkUrl {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:linkUrl]];
    UIImage *image = [UIImage imageWithData:imageData];
    [self performSelectorOnMainThread:@selector(putImage:) withObject:image waitUntilDone:NO];
    
    [pool release];
}



#pragma mark - PhotoAPIModel Delegate
- (void) requestDone:(PhotoAPIParserModel*) resultData {
    if ([resultData total] != nil) {
        totalItemCount = [[resultData total] intValue];
        return;
    }
    
    [resultData setIndex:[_photoList count]];
    [_photoList addObject:resultData];
    
    NSRange foundSlrClub = [resultData.thumbnail rangeOfString:@"slrclub"];
    if (foundSlrClub.location != NSNotFound) {
        downLoadCount++;
        if (totalItemCount == [_photoList count] || downLoadCount == naverImageDownloadCount) {
            _isRequestingQuery = NO;
        }
        return;
    }
    [_photoListView makeFrame:resultData];
    dispatch_async(dqueue, ^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[resultData thumbnail]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [resultData setDownloadImage:[UIImage imageWithData:imageData]];
                [_photoListView setImageData:resultData];
                downLoadCount++;
            });
            
        });
    });
    if (totalItemCount == [_photoList count] || downLoadCount == naverImageDownloadCount) {
        _isRequestingQuery = NO;
    }
}

- (void) apiRequestError:(NSError *) error {
    _isRequestingQuery = NO;
    downLoadCount = 0;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
    switch ([error code]) {
        case -1001:
            alertView.message = [NSString stringWithFormat:@"%@ \ncode=%d",kNetworkErrorAlertMessage, [error code]];
            break;            
        default:
            alertView.message = [NSString stringWithFormat:@"%@ \ncode=%d",kDefaultErrorAlertMessage, [error code]];
            break;
    }
    [alertView show];
    [alertView release];
}

- (void) connectionFinish {
    _isRequestingQuery = NO;
}
#pragma scrollview delegate
- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_isRequestingQuery || totalItemCount == [_photoList count]) {
        return;
    }
    
    if (lastOffsetY > scrollView.contentOffset.y) {
        return;
    }
    if (fabs(scrollView.contentOffset.y - _photoListView.maxHeight) > [[UIScreen mainScreen] applicationFrame].size.height * 6) {
        return;
    }
    
    _isRequestingQuery = YES;
    downLoadCount = 0;
    
    switch (photoListType) {
        case PHOTO_LIST_BY_SEARCH:
            [[PhotoAPIModel getSharedInstance] getPhotoListBySearchText:_searchText withEngine:searchEngine startIndex:[_photoList count]+1];
            break;
        default:
            break;
    } 
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    lastOffsetY = scrollView.contentOffset.y;
}

@end
