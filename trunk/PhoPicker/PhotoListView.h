//
//  PhotoListView.h
//  PhoPicker
//
//  Created by 백 승필 on 12. 4. 12..
//  Copyright (c) 2012 NHN Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoFrameView.h"
#import "PhotoAPIXMLParser.h"
#import "UIConstants.h"
@interface PhotoListView : UIScrollView {
    PhotoFrameView *firstFrameView;
    PhotoFrameView *secondFrameView;
    PhotoFrameView *thirdFrameView;
}

- (void) setImageData:(PhotoAPIParserModel *) resultModel;
- (PhotoFrameView *) minHeightView;
@end
