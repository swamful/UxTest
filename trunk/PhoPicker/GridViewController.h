//
//  GridViewController.h
//  PhoPicker
//
//  Created by 백 승필 on 12. 8. 9..
//  Copyright (c) 2012 NHN Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeHomeGridView.h"
@interface GridViewController : UIViewController {
    NSDictionary *data;
    MeHomeGridView *gridView;
}

@property (nonatomic, retain) NSDictionary *data;
@end
