//
//  DrawViewController.h
//  ComicMe
//
//  Created by Stefan Verveniotis on 2016-11-29.
//  Copyright © 2016 Midterm Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaintView.h"
@class DrawViewController;

@protocol DrawViewDelegate <NSObject>

- (void) addDrawView:(DrawViewController *)drawViewController;

@end

@interface DrawViewController : UIViewController

@property (weak, nonatomic) id<DrawViewDelegate> delegate;

- (void) attachDrawView:(PaintView *)paintView;

@end
