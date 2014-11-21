//
//  AppUtility.m
//  PhoPicker
//
//  Created by 백 승필 on 12. 4. 25..
//

#import "AppUtility.h"

@implementation AppUtility
static UIActivityIndicatorView *indicator;
+ (void)layoutIndicator:(UIView *)aview{
	CGSize size = aview.bounds.size;
	CGSize mysize = [indicator sizeThatFits:size];
	indicator.frame = CGRectMake(roundf((size.width - mysize.width) / 2), roundf((size.height - mysize.height) / 2), mysize.width, mysize.height);
}

+ (void)showIndicator:(UIView *)aview {
    if (!indicator) {
        indicator = [[UIActivityIndicatorView alloc] init];
    }
        
	[aview addSubview:indicator];
	[self layoutIndicator:aview];
	
	[indicator startAnimating];
}


+ (void)hideIndicator {
    if ( ![indicator isAnimating] ) return;
	[indicator stopAnimating];
	[indicator removeFromSuperview];
}

+ (void)setIndicatorStyleWhiteLarge {
	[indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
}

+ (void)setIndicatorStyleGray {
	if(indicator.activityIndicatorViewStyle!=UIActivityIndicatorViewStyleGray)
		[indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
}

+ (void)setIndicatorStyleWhite {
	if(indicator.activityIndicatorViewStyle!=UIActivityIndicatorViewStyleWhite)
		[indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
}
@end
