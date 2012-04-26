//
//  PhotoListView.m
//  PhoPicker
//
//  Created by 백 승필 on 12. 4. 12..
//  Copyright (c) 2012 NHN Corp. All rights reserved.
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
        thirdFrameView = [[PhotoFrameView alloc] initWithFrame:CGRectMake((listFrameWidth + listFrameMargin) * 2, 2, listFrameWidth, 0)];
        [self addSubview:firstFrameView];
        [firstFrameView release];
        [self addSubview:secondFrameView];
        [secondFrameView release];
        [self addSubview:thirdFrameView];
        [thirdFrameView release];
    }
    return self;
}

- (PhotoFrameView *) minHeightView {
    NSInteger first = firstFrameView.frameHeight;
    NSInteger second = secondFrameView.frameHeight;
    NSInteger third = thirdFrameView.frameHeight;
    
    if (first >= second) {
        if (second >= third) {
//            NSLog(@"third");
            return thirdFrameView;
        } else {
//                NSLog(@"second");
            return secondFrameView;
        }
    } else {
        if (first < third) {
//                        NSLog(@"first");
            return firstFrameView;
        } else {
//                NSLog(@"third");
            return thirdFrameView;
        }
    }
}

- (void) setImageData:(PhotoAPIParserModel *) resultModel {
    PhotoFrameView *frameView = [self minHeightView];
    [frameView makeButtonDown:resultModel];
    CGSize orgSize = CGSizeMake([[resultModel sizeWidth] intValue], [[resultModel sizeHeight] intValue]);
    NSInteger imgHeight = (orgSize.height * listFrameWidth) /orgSize.width;
    [self setContentSize:CGSizeMake(self.frame.size.width, frameView.frameHeight + imgHeight)];
}


@end
