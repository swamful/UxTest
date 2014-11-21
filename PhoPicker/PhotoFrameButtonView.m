//
//  PhotoFrameButtonView.m
//  PhoPicker
//
//  Created by 백 승필 on 12. 4. 12..
//

#import "PhotoFrameButtonView.h"
#import "AppUtility.h"
@implementation PhotoFrameButtonView
@synthesize index, isFirstFrame = _isFirstFrame;

- (void)showIndicator {
    if (!indicator) {
        indicator = [[UIActivityIndicatorView alloc] init];
    }
    
	[self addSubview:indicator];
    [indicator release];
	CGSize size = self.bounds.size;
	CGSize mysize = [indicator sizeThatFits:size];
	indicator.frame = CGRectMake(roundf((size.width - mysize.width) / 2), roundf((size.height - mysize.height) / 2), mysize.width, mysize.height);
	
	[indicator startAnimating];
}


- (void)hideIndicator {
    if ( ![indicator isAnimating] ) return;
	[indicator stopAnimating];
	[indicator removeFromSuperview];
}

@end
