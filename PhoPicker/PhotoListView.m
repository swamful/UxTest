//
//  PhotoListView.m
//  PhoPicker
//
//  Created by 백 승필 on 12. 4. 12..
//

#import "PhotoListView.h"
#import "PhotoFrameView.h"

@interface PhotoListView()
- (PhotoFrameView *) minHeightView;
@end

@implementation PhotoListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        firstFrameView = [[PhotoFrameView alloc] initWithFrame:CGRectMake(0, 2, listFrameWidth, 0)];        
        secondFrameView = [[PhotoFrameView alloc] initWithFrame:CGRectMake(listFrameWidth + listFrameMargin, 2, listFrameWidth, 0)];

        [self addSubview:firstFrameView];
        [firstFrameView release];
        [self addSubview:secondFrameView];
        [secondFrameView release];
    }
    return self;
}

- (PhotoFrameView *) minHeightView {
    NSInteger first = firstFrameView.frameHeight;
    NSInteger second = secondFrameView.frameHeight;
    
    if (first > second) {
        return secondFrameView;
    } else {
        return firstFrameView;
    }
}

- (CGFloat) maxHeight {
    NSInteger first = firstFrameView.frameHeight;
    NSInteger second = secondFrameView.frameHeight;
    
    if (first > second) {
        return firstFrameView.frame.size.height;
    } else {
        return secondFrameView.frame.size.height;
    }
}

- (void) setImageData:(PhotoAPIParserModel *) resultModel {
    if ([firstFrameView.btnDictionary objectForKey:[NSString stringWithFormat:@"%d", resultModel.index]]) {
        [firstFrameView setImage:resultModel];
    } else if ([secondFrameView.btnDictionary objectForKey:[NSString stringWithFormat:@"%d", resultModel.index]]) {
        [secondFrameView setImage:resultModel];        
    }
}

- (void) makeFrame:(PhotoAPIParserModel *)resultModel {
    PhotoFrameView *frameView = [self minHeightView];
    [frameView makeButtonDown:resultModel];
    CGFloat contentSizeHeight = MAX(self.contentSize.height, frameView.frameHeight + 40);    
    [self setContentSize:CGSizeMake(self.frame.size.width, contentSizeHeight)];
}

@end
