//
//  MainView.h
//  PhoPicker
//
//  Created by 백 승필 on 12. 9. 21..
//

#import <UIKit/UIKit.h>
#import "XMovieUpView.h"
@interface MainView : UIView <UITextFieldDelegate> {

    UITextField *text;
}

@property (nonatomic, retain) UITextField *text;

@end
