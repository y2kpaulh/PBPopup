//
//  PBPopupView.m
//  PBPopUpViewExample
//
//  Created by 김성민 on 2014. 10. 14..
//  Copyright (c) 2014년 Purple. All rights reserved.
//

#import "PBPopup.h"

@interface UIView (FirstResponder)

- (instancetype)findFirstResponder;

@end

@implementation UIView (FirstResponder)

- (instancetype)findFirstResponder
{
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subView in self.subviews) {

        UIView* resultView = [subView findFirstResponder];

        if(resultView){
            return resultView;
        }
    }
    return nil;
}

@end

@interface PBPopup ()

@property BOOL canHide;

@end

@implementation PBPopup

@synthesize shouldHideOnClickAtBackground = _shouldHideOnClickAtBackground;



-(instancetype)init{
    
    self = [super init];
    if(self){
        
        @throw [NSException exceptionWithName:[NSString stringWithFormat:@"Do not use %s",__PRETTY_FUNCTION__] reason:@"Always use intiWithParentView[Controller]: contentView[Controller]:" userInfo:nil];
    }
    
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if(self){
        @throw [NSException exceptionWithName:[NSString stringWithFormat:@"Do not use %s",__PRETTY_FUNCTION__] reason:@"Always use intiWithParentView[Controller]: contentView[Controller]:" userInfo:nil];
    }
    return self;
}



-(void)setUpWithParentView:(UIView*)parentView contentViewController:(UIViewController*)contentViewController{
    
    _shouldMoveContentViewWhenKeyboardIsShowingAndHiding = YES;
    _canHide = YES;
    _hideDelay = -1;
    _contentMovingUpMargin = 4;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
    
    
    _parentView = parentView;
    _contentViewController = contentViewController;
    _contentView = contentViewController.view;
    
   // [_parentViewController addChildViewController:_contentViewController];
    
    if(_parentView == nil){
        @throw [NSException exceptionWithName:@"parentView error"
                                       reason:@"parentView is nil" userInfo:nil];
    }
    
    if(_contentViewController == nil || _contentView == nil){
        @throw [NSException exceptionWithName:@"contentView error"
                                       reason:@"contentView is nil" userInfo:nil];
    }
    
    
    
    //If I just set self.alpha with value less than 1.0, subview is applied too.
    //So, this is bypass.
    [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.7f]];
    self.shouldHideOnClickAtBackground = YES;
    
    [self resetPosition];
    
    [self addSubview:_contentView];
    
}

-(void)resetPosition{
    
    CGRect rect = _contentView.frame;
    
    rect.origin.x = (self.parentView.frame.size.width - rect.size.width) / 2 ;
    rect.origin.y = (self.parentView.frame.size.height - rect.size.height) / 2 ;
    
    [_contentView setNeedsUpdateConstraints];
    [_contentView setFrame:rect];
    
    
}
-(instancetype)initWithParentView:(UIView*)parentView
            contentViewController:(UIViewController*)contentViewController{
    
    self = [super initWithFrame:parentView.frame];
    if(self){
        
        [self setUpWithParentView:parentView contentViewController:contentViewController];
    }
    
    return self;
}
-(instancetype)initWithParentViewController:(UIViewController *)parentViewController
                      contentViewController:(UIViewController *)contentViewController{
    self = [super initWithFrame:parentViewController.view.frame];
    
    if(self){
        
        _parentViewController = parentViewController;
        
        [self setUpWithParentView:parentViewController.view contentViewController:contentViewController];
        
    }
    
    return self;
}
-(instancetype)initWithParentViewController:(UIViewController *)parentViewController
                                contentView:(UIView*)contentView{
    
    self = [super initWithFrame:parentViewController.view.frame];
    if(self){
        
        [self setUpDefaultUIViewControllerForContentView:contentView];
        
        [self setUpWithParentView:parentViewController.view contentViewController:_contentViewController];
        
        
    }
    
    return self;
    
}
-(instancetype)initWithParentView:(UIView*)parentView
                      contentView:(UIView*)contentView{
    
    self = [super initWithFrame:parentView.frame];
    if(self){
        
        [self setUpDefaultUIViewControllerForContentView:contentView];
        
        [self setUpWithParentView:parentView contentViewController:_contentViewController];
        
    }
    
    return self;
    
}
-(void)setUpDefaultUIViewControllerForContentView:(UIView*)contentView{
    
    _contentViewController = [[UIViewController alloc] init];
    _contentViewController.view.frame = contentView.frame;
    _contentViewController.view.backgroundColor = [UIColor clearColor];
    [_contentViewController.view addSubview:contentView];
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    
    if(touch.view == self){
        
        return YES;
        
    }
    else{
        
        return (_shouldHideOnClickAtContent)?YES:NO;
        
    }
    
}
-(void)addGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer{
    
    //밖에서 직접 gesture recognizer를 넣는것을 막기 위한것
    //자유도를 제약할까?
    if(self.gestureRecognizers.count < 1)
        [super addGestureRecognizer:gestureRecognizer];
}


- (BOOL)shouldHideOnClickAtBackground{
    
    return _shouldHideOnClickAtBackground;
    
}
- (void)setShouldHideOnClickAtBackground:(BOOL)shouldHide{
    
    _shouldHideOnClickAtBackground = shouldHide;
    
    UITapGestureRecognizer* gr =
    (self.gestureRecognizers.count>0)? self.gestureRecognizers[0] : nil;
    
    
    if(shouldHide){
        
        if(gr == nil){
            
            gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
            gr.delegate = self;
            [self addGestureRecognizer:gr];
            
        }
        
    }else{
        
        if(gr != nil)
            [self removeGestureRecognizer:gr];
        
    }
    
}

- (void)keyboardWillShow:(NSNotification* )sender{

    NSNumber *durationValue = sender.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = durationValue.doubleValue;

    NSNumber *curveValue = sender.userInfo[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.intValue;

    NSDictionary* info = [sender userInfo];
    CGSize kbSize = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;

    if(_shouldMoveContentViewWhenKeyboardIsShowingAndHiding){





        float keyboardHeight = kbSize.height;

        [UIView animateWithDuration:animationDuration
                              delay:0.0
                            options:(animationCurve << 16)
                         animations:^{

                             UIWindow* window = [[UIApplication sharedApplication] keyWindow];



                             UIView* firstResponder = [self findFirstResponder];

                             CGRect newFrame = [firstResponder convertRect:firstResponder.bounds toView:nil];

                             if((newFrame.origin.y + newFrame.size.height + _contentMovingUpMargin) > SCREEN_HEIGHT - keyboardHeight){


                                 CGRect originalRect = window.frame;

                                 originalRect.origin.y = -(_contentMovingUpMargin + keyboardHeight - (SCREEN_HEIGHT - (newFrame.origin.y + newFrame.size.height)));


                                 window.frame = originalRect;

                             }


                         }

                         completion:^(BOOL completed){

                         }
         ];


        
    }
    
    
    
}
- (void)keyboardWillHide:(NSNotification* )sender{
    NSDictionary *userInfo = [sender userInfo];
    
    NSTimeInterval animationDuration = [[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSInteger curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
    
    
    [UIView animateWithDuration:animationDuration delay:0 options:curve animations:^{

        UIWindow* window = [[UIApplication sharedApplication] keyWindow];
        CGRect rect = window.frame;
        rect.origin.y = 0;
        window.frame = rect;


    } completion:nil];
    
}

-(void)showAnimated{
    
    [self resetPosition];
    
     _contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    
    if(_willShowHandler)
        _willShowHandler(self,_parentView,_contentViewController);
    [_parentView addSubview:self];
    
    __weak PBPopup* popup = self;
    
    if(_hideDelay >= 0){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_hideDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [popup hide];
        });
    }
    
  

    
    [UIView animateWithDuration:0.4/1.5 animations:^{
        _contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3/2 animations:^{
            _contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3/2 animations:^{
                _contentView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                if(_didShowHandler)
                    _didShowHandler(self,_parentView,_contentViewController);
            }];
        }];
    }];
    
}
-(void)show{
    
    [self resetPosition];
    
    if(_willShowHandler)
        _willShowHandler(self,_parentView,_contentViewController);
    [_parentView addSubview:self];
    
    __weak PBPopup* popup = self;
    
    if(_hideDelay >= 0){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_hideDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [popup hide];
        });
    }
    
    if(_didShowHandler)
        _didShowHandler(self,_parentView,_contentViewController);
    
}
-(void)hide{

    [self endEditing:YES];
    
    if(_canHide){
        if(_willHideHandler)
            _willHideHandler(self,_parentView,_contentViewController,_extraObject);
        [self removeFromSuperview];
        if(_didHideHandler)
            _didHideHandler(self,_parentView,_extraObject);
    }
}

-(void)showAndhideAfterDelay:(float)seconds{
    
    _hideDelay = seconds;
    
    [self show];
    
}-(void)showAndShouldNotBeHiddenForSeconds:(float)notBeforeSeconds hideAfterDelay:(float)hideAfterSeconds{
    
    _canHide = NO;
    
    [self showAndhideAfterDelay:hideAfterSeconds];
    
    if(notBeforeSeconds > 0){
        
        __weak PBPopup* popup = self;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(notBeforeSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           
            popup.canHide = YES;
            
        });
    }
    
    
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
