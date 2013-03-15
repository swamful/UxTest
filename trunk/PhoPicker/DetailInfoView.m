//
//  DetailInfoView.m
//  PhoPicker
//
//  Created by 백 승필 on 12. 4. 26..
//  Copyright (c) 2012 NHN Corp. All rights reserved.
//

#import "DetailInfoView.h"
#import "UIConstants.h"
#import "AppUtility.h"

#define detailTextHeight 70
@interface DetailInfoView()
- (void) makeMainView;
- (void) makeCloseBtn;
- (void) makePhotoView;
- (void) playAnimation;
- (CGRect) imageSizeRect;
@end


@implementation DetailInfoView
@synthesize dataModel = _dataModel;
- (id)initWithFrame:(CGRect)frame withDataModel:(PhotoAPIParserModel *) dataModel
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataModel = dataModel;
        [self makeMainView];
        [self makeCloseBtn];
        [self makePhotoView];
        
        UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tapRecognizer.numberOfTapsRequired = 2;
        [self addGestureRecognizer:tapRecognizer];
        [tapRecognizer release];
    }
    return self;
}

- (void) dealloc {
    self.dataModel = nil;
    [super dealloc];
}

- (void)handleTap:(UITapGestureRecognizer*)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer*)recognizer;
        CGPoint location = [pan locationInView:pan.view];
        if(CGRectContainsPoint(_photoFrame.frame, location)) {
            [self playAnimation];            
        }
    }
}

- (void) playAnimation {
    CGFloat scaleRate = self.frame.size.width / _photoFrame.image.size.width;
    [UIView animateWithDuration:0.3 animations:^() {
        if (_photoFrame.frame.size.width == self.frame.size.width) {
            _photoFrame.frame = [self imageSizeRect];
        } else {
            _photoFrame.frame = CGRectMake(0, 50, _photoFrame.image.size.width * scaleRate, _photoFrame.image.size.height * scaleRate);  
        }
    } completion:^(BOOL finish) {
        [_mainView setContentSize:CGSizeMake(320, _photoFrame.frame.origin.y + _photoFrame.frame.size.height + detailTextHeight)];
    }];
}


- (void) makeMainView {
    _mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:_mainView];
    [_mainView release];
}

- (CGRect) imageSizeRect {
    CGSize imageSize = CGSizeMake([[_dataModel sizeWidth] floatValue], [[_dataModel sizeHeight] floatValue]);
    CGSize frameSize = imageSize;
    CGPoint framePoint = CGPointMake(50, 50);
    if (imageSize.width > 220) {
        frameSize.width = 220;
        frameSize.height = imageSize.height * frameSize.width / imageSize.width;
    } else {
        framePoint.x = ([[UIScreen mainScreen] bounds].size.width - frameSize.width) / 2;
    }

    return CGRectMake(framePoint.x, framePoint.y, frameSize.width, frameSize.height);
}

- (void)makePhotoView {

    _photoFrame = [[UIImageView alloc] initWithFrame:[self imageSizeRect]];
    _photoFrame.backgroundColor = UICOLOR_DCDCDC;
    _photoFrame.image = [self.dataModel downloadImage];
    [_mainView addSubview:_photoFrame];
    [_photoFrame release];
    
    [_mainView setContentSize:CGSizeMake(320, _photoFrame.frame.origin.y + _photoFrame.frame.size.height + detailTextHeight)];
}


- (void) makeCloseBtn {
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setFrame:CGRectMake(280, 10, 23, 23)];
    [closeBtn setImage:[UIImage imageNamed:@"btn_close.png"] forState:UIControlStateNormal];
    [closeBtn addTarget:nil action:@selector(actionDetailViewClose) forControlEvents:UIControlEventTouchUpInside];
    [_mainView addSubview:closeBtn];
}

- (void) putImage:(UIImage *) image {
    [_photoFrame setImage:image];
}

@end
