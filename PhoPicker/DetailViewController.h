//
//  DetailViewController.h
//  PhoPicker
//
//  Created by 백 승필 on 12. 4. 25..
//  Copyright (c) 2012 NHN Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoAPIXMLParser.h"
@interface DetailViewController : UIViewController {
    PhotoAPIParserModel *_dataModel;
    UIImageView *_photoFrame;
    UIScrollView *_mainView;
}

- (id) initWithDataModel:(PhotoAPIParserModel*) dataModel;
@end
