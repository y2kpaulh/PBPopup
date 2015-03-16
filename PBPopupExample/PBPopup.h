//
//  PBPopupView.h
//  PBPopUpViewExample
//
//  Created by 김성민 on 2014. 10. 14..
//  Copyright (c) 2014년 Purple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//Int casting is for switch statement
#define SCREEN_WIDTH ((unsigned int)[[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ((unsigned int)[[UIScreen mainScreen] bounds].size.height)

#define IPHONE4_4S_HEIGHT  (480)
#define IPHONE5_5S_HEIGHT  (568)
#define IPHONE6_HEIGHT     (667)
#define IPHONE6PLUS_HEIGHT (736)


#ifndef WINDOW_OVER_KEYBOARD
#define WINDOW_OVER_KEYBOARD [UIApplication sharedApplication].windows.lastObject
#endif

#define kMarginBetweenContentViewAndKeyboard 20.0f

@interface PBPopup : UIView<UIGestureRecognizerDelegate>



-(instancetype)initWithParentViewController:(UIViewController*)parentViewController
					  contentViewController:(UIViewController*)contentViewController ;



-(instancetype)initWithParentView:(UIView*)parentView
			contentViewController:(UIViewController*)contentViewController;

-(instancetype)initWithParentViewController:(UIViewController *)parentViewController
								contentView:(UIView*)contentView ;

-(instancetype)initWithParentView:(UIView*)parentView
					  contentView:(UIView*)contentView ;


-(void)resetPosition;

@property (readonly) float hideDelay; //valid only with positive or zero value

@property (strong, nonatomic) id extraObject;

@property (weak, nonatomic) UIViewController* parentViewController; //nil if not set
@property (weak, nonatomic) UIView* parentView; //parentView which contentView is added to as subview

@property (strong, nonatomic) UIViewController* contentViewController; //'Default UIViewController' with contentView if not passed in -init~~
@property (strong, nonatomic) UIView* contentView;



@property BOOL shouldMoveContentViewWhenKeyboardIsShowingAndHiding; // if set YES, content view will move up when keyboard shows up and move down when keyboard gets hidden
@property float contentMovingUpMargin; //default is 4

@property BOOL shouldHideOnClickAtBackground; //default is YES
@property BOOL shouldHideOnClickAtContent;    //default is NO


@property (copy) void (^didShowHandler)(PBPopup *popup,UIView *parentView, UIViewController* contentViewController);
@property (copy) void (^willShowHandler)(PBPopup *popup, UIView *parentView,UIViewController* contentViewController);

@property (copy) void (^didHideHandler)(PBPopup *popup,UIView *parentView, id extraObject);
@property (copy) void (^willHideHandler)(PBPopup *popup, UIView *parentView,UIViewController* contentViewController, id extraObject);


-(void)showAnimated;
-(void)show;
-(void)hide;
-(void)showAndhideAfterDelay:(float)seconds;
-(void)showAndShouldNotBeHiddenForSeconds:(float)notBeforeSeconds hideAfterDelay:(float)hideAfterSeconds;



@end
