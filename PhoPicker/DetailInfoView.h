//
//  DetailInfoView.h
//  PhoPicker
//
//  Created by 백 승필 on 12. 4. 26..
//  Copyright (c) 2012 NHN Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoAPIXMLParser.h"

@interface DetailInfoView : UIView <UIGestureRecognizerDelegate> {
    UIImageView *_photoFrame;
    UIScrollView *_mainView;
    PhotoAPIParserModel *_dataModel;
    
    CALayer *layer;
}

@property (nonatomic, assign) PhotoAPIParserModel *dataModel;

- (id)initWithFrame:(CGRect)frame withDataModel:(PhotoAPIParserModel *) dataModel;
- (void) putImage:(UIImage *) image;
@end
