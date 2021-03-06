//  KNPathTableViewController.h
//
//  Created by Kent Nguyen 12/1/12.
//  Copyright (c) 2012. All rights reserved.
//
//
//
//
//  HOWTO:
//  Make a custom class from this class
//  and override custom methods found below.
//
//  Adjust the constants below to suit your needs.
//
//  IMPORTANT:
//  If you need to override UIScrollViewDelegate methods,
//  remember to call [super]
//
//

#import <UIKit/UIKit.h>

#define KNPathTableFadeInDuration         0.3
#define KNPathTableFadeOutDuration        0.3
#define KNPathTableFadeOutDelay           0.5
#define KNPathTableSlideInOffset         16.0
#define KNPathTableOverlayDefaultSize    CGSizeMake(150, 32)

@interface KNPathTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>
{
    // The additional small overlay hovering above table view
    UIView * __infoPanel;
    
    // The label within the above overlay
    UILabel * infoLabel;
    
    // Geometric parameters of the above overlay
    CGSize   __infoPanelSize;
    CGRect   __infoPanelInitialFrame;
    CGFloat  __initalScrollIndicatorHeight;
}

@property (nonatomic,readonly) UIView * infoPanel;

-(id)initWithStyle:(UITableViewStyle)style;
-(id)initWithStyle:(UITableViewStyle)style infoPanelSize:(CGSize)size;

// Override these
-(void)infoPanelWillAppear:(UIScrollView*)scrollView;
-(void)infoPanelDidAppear:(UIScrollView*)scrollView;
-(void)infoPanelWillDisappear:(UIScrollView*)scrollView;
-(void)infoPanelDidDisappear:(UIScrollView*)scrollView;
-(void)infoPanelDidScroll:(UIScrollView*)scrollView atPoint:(CGPoint)point;
-(void)infoPanelDidStopScrolling:(UIScrollView*)scrollView;

@end
