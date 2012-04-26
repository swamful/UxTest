//
//  PhotoFrameView.m
//  PhoPicker
//
//  Created by 백 승필 on 12. 4. 12..
//  Copyright (c) 2012 NHN Corp. All rights reserved.
//

#import "PhotoFrameView.h"
#import "PhotoFrameButtonView.h"
#import "AppUtility.h"
@implementation PhotoFrameView
@synthesize frameHeight;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        for (int i = 1; i < 16; i++) {
            PhotoFrameButtonView *frameButton = [[PhotoFrameButtonView alloc] init];
            frameButton.tag = i;
            frameButton.enabled = NO;
            frameButton.frame = CGRectMake(0, 0, listFrameWidth, 0);
            [frameButton addTarget:nil action:@selector(getLargePhoto:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:frameButton];
        }
        
    }
    return self;
}

- (NSInteger) frameHeight {
    return self.frame.origin.y + self.frame.size.height;
}

- (PhotoFrameButtonView *) getFrameButton {
    for (int i = 1; i < 16; i++) {
        PhotoFrameButtonView *frameButton = (PhotoFrameButtonView*)[self viewWithTag:i];
        if (!frameButton.enabled) {
            frameButton.enabled = YES;
            return frameButton;
        }
    }
    return (PhotoFrameButtonView*)[self viewWithTag:1];
}

- (void) makeButtonDown:(PhotoAPIParserModel *) parserModel {
    PhotoFrameButtonView *frameButton = [self getFrameButton];
    frameButton.index = [parserModel index];
    CGSize orgSize = CGSizeMake([[parserModel sizeWidth] intValue], [[parserModel sizeHeight] intValue]);
    NSInteger imgHeight = (orgSize.height * listFrameWidth) /orgSize.width;
    frameButton.frame = CGRectMake(0, self.frameHeight, listFrameWidth, imgHeight);
    NSLog(@"framebtn :%@", NSStringFromCGRect(frameButton.frame));
    frameButton.backgroundColor = [UIColor blackColor];
    [frameButton setImageInBackground:[parserModel thumbnail] forState:UIControlStateNormal];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, listFrameWidth, self.frameHeight + imgHeight); 
}

@end
