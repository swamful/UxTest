//
//  MainView.h
//  PhoPicker
//
//  Created by 백 승필 on 12. 9. 21..
//  Copyright (c) 2012 NHN Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMovieUpView.h"
@interface MainView : UIView <UITextFieldDelegate> {

    UITextField *text;
}

@property (nonatomic, retain) UITextField *text;

@end
