//
//  PhotoListView.h
//  PhoPicker
//
//  Created by 백 승필 on 12. 4. 12..
//

#import <UIKit/UIKit.h>
#import "PhotoFrameView.h"
#import "PhotoAPIXMLParser.h"
#import "UIConstants.h"

@interface PhotoListView : UIScrollView {
    PhotoFrameView *firstFrameView;
    PhotoFrameView *secondFrameView;
}

- (void) setImageData:(PhotoAPIParserModel *) resultModel;
- (void) makeFrame:(PhotoAPIParserModel *) resultModel;
- (PhotoFrameView *) minHeightView;
- (CGFloat) maxHeight;
@end
