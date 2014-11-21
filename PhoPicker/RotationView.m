//
//  RotationView.m
//  PhoPicker
//
//  Created by 백 승필 on 12. 9. 6..
//

#import "RotationView.h"
@interface RotationView()
- (CATransform3D) getTransForm3DIdentity;
@end
@implementation RotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        panRecognizer.minimumNumberOfTouches = 1;
        [self addGestureRecognizer:panRecognizer];
        [panRecognizer release];
        
        self.layer.sublayerTransform = [self getTransForm3DIdentity];
        
        descLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 350, 150, 60)];
        descLabel.backgroundColor = [UIColor whiteColor];
        [self addSubview:descLabel];
        [descLabel release];
    }
    layerList = [[NSMutableArray alloc] init];
    NSMutableArray * urlList = [[NSMutableArray alloc] initWithObjects:@"http://www.naver.com",@"http://www.daum.net",@"http://www.nate.com",@"http://news.naver.com"
                                ,@"http://blog.naver.com",@"http://cafe.naver.com", nil];
    
    for (int i = 0 ; i < 6 ; i++ ) {
        UIWebView *webview = [[UIWebView alloc] initWithFrame:CGRectMake(50, 50, 200, 250)];
        webview.tag = i;
        [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[urlList objectAtIndex:i]]]];
        webview.delegate = self;
        [self addSubview:webview];
        [webview release];
        
        webview.layer.cornerRadius = 10.0f;
        webview.layer.transform = [self getTransForm3DIdentity];
        webview.layer.transform = CATransform3DTranslate(webview.layer.transform, -70 + i * 35, 0, 0 );
        [self.layer addSublayer:webview.layer];        
        [layerList addObject:webview.layer];        
    }

    return self;
}

- (void) webViewDidStartLoad:(UIWebView *)webView {
    descLabel.text = [NSString stringWithFormat:@"%d 번 쨰 view", [webView tag]];
}

- (void) selectView:(id) sender {
    
}
- (void) dealloc {
    [layerList release];
    [super dealloc];
}

- (CATransform3D) getTransForm3DIdentity {
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = - 1.0f/ 1000.0f;
    return transform;
}

#pragma mark - GestureReconizer
- (void) handlePan:(UIPanGestureRecognizer *) recognizer {
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *) recognizer;
    CGPoint delta = [pan translationInView:pan.view];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        forePoint = CGPointZero;
    }
    
    for (CALayer *layer in layerList) {
        layer.transform = CATransform3DRotate(layer.transform, DEGREES_TO_RADIANS((forePoint.x - delta.x) * 0.5), 0, 1, 0);
        layer.transform = CATransform3DRotate(layer.transform, DEGREES_TO_RADIANS((forePoint.y - delta.y) * 0.5), 1, 0, 0);        
    }
    forePoint = delta;
}

@end
