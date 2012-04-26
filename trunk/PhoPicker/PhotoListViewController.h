//
//  PhotoListViewController.h
//  PhoPicker
//
//  Created by 백 승필 on 12. 4. 12..
//  Copyright (c) 2012 NHN Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoListView.h"
#import "PhotoAPIModel.h"
#import "UIConstants.h"
@interface PhotoListViewController : UIViewController <PhotoAPIModelDelegate, UIScrollViewDelegate> {
    PhotoListView *_photoListView;
    NSMutableArray *_photoList;
    PhotoListType photoListType;
    NSString *_searchText;
    
    SEARCHENGINE searchEngine;
}

@property (nonatomic, retain) NSString *searchText;
@property (nonatomic) SEARCHENGINE searchEngine;
- (id) initWithType:(PhotoListType) type;
@end
