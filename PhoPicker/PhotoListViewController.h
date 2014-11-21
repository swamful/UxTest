//
//  PhotoListViewController.h
//  PhoPicker
//
//  Created by 백 승필 on 12. 4. 12..
//

#import <UIKit/UIKit.h>
#import "PhotoListView.h"
#import "PhotoAPIModel.h"
#import "UIConstants.h"
#import "TitleView.h"
#import "DetailInfoView.h"

@interface PhotoListViewController : UIViewController <PhotoAPIModelDelegate, UIScrollViewDelegate> {
    PhotoListView *_photoListView;
    TitleView *titleView;
    DetailInfoView *infoView;
    
    NSMutableArray *_photoList;
    PhotoListType photoListType;
    NSString *_searchText;
    
    SEARCHENGINE searchEngine;
    
    dispatch_queue_t dqueue;
    NSInteger count;
    
    CALayer *layer;
    BOOL _isRequestingQuery;
    NSInteger totalItemCount;
    NSInteger downLoadCount;
    
    CGFloat lastOffsetY;
}

@property (nonatomic, retain) NSString *searchText;
@property (nonatomic) SEARCHENGINE searchEngine;
- (id) initWithType:(PhotoListType) type;
@end
