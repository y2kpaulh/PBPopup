//The MIT License (MIT)
//
//Copyright (c) <2015> <Sungmin Kim> (purpleblues568@gmail.com)
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.


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
