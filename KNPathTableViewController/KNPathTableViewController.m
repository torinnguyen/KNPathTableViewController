//
//  KNPathTableViewController.m
//  
//
//  Created by Kent Nguyen 12/1/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "KNPathTableViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface KNPathTableViewController (private)
-(void)moveInfoPanelToSuperView;
-(void)moveInfoPanelToIndicatorView;
-(void)slideOutInfoPanel;
@end

@implementation KNPathTableViewController

#pragma mark - The properties

@synthesize infoPanel = __infoPanel;

#pragma mark - Custom init

-(id)initWithStyle:(UITableViewStyle)style {
    if ((self = [self initWithStyle:style infoPanelSize:KNPathTableOverlayDefaultSize])) {
    }
    return self;
}

-(id)initWithStyle:(UITableViewStyle)style infoPanelSize:(CGSize)size
{
    self = [super initWithStyle:style];
    if (self)
    {
        __infoPanelSize = size;
    }
    return self;
}

#pragma mark - View lifecycle

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //Not yet init by the above init functions
    if (__infoPanelSize.width == 0 || __infoPanelSize.height == 0)
        __infoPanelSize = KNPathTableOverlayDefaultSize;
    
    // The tableview
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
    
    // The panel
    __infoPanelSize = __infoPanelSize;
    __infoPanelInitialFrame = CGRectMake(-__infoPanelSize.width, 0, __infoPanelSize.width, __infoPanelSize.height);
    __infoPanel = [[UIView alloc] initWithFrame:__infoPanelInitialFrame];
    
    // Initialize overlay panel with stretchable background
    UIImageView * bg = [[UIImageView alloc] initWithFrame:__infoPanel.bounds];
    UIImage * overlay = [UIImage imageNamed:@"KNTableOverlay"];
    bg.image = [overlay stretchableImageWithLeftCapWidth:overlay.size.width/2.0 topCapHeight:overlay.size.height/2.0];
    [__infoPanel setAlpha:0];
    [__infoPanel addSubview:bg];

    // Initialize text label inside overlay panel
    if (infoLabel == nil)
    {
        infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 4, 140, 20)];
        infoLabel.font = [UIFont boldSystemFontOfSize:12];
        infoLabel.textAlignment = UITextAlignmentLeft;
        infoLabel.textColor = [UIColor whiteColor];
        infoLabel.shadowColor = [UIColor blackColor];
        infoLabel.backgroundColor = [UIColor clearColor];
        infoLabel.shadowOffset = CGSizeMake(0, 1);
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - Basic use for the info panel (to be override by subclass)

-(void)infoPanelDidAppear:(UIScrollView*)scrollView {}
-(void)infoPanelWillDisappear:(UIScrollView*)scrollView {}
-(void)infoPanelDidDisappear:(UIScrollView*)scrollView {}
-(void)infoPanelDidStopScrolling:(UIScrollView*)scrollView {}

#pragma mark - Basic use for the info panel

-(void)infoPanelWillAppear:(UIScrollView *)scrollView {
    if (![infoLabel superview]) [self.infoPanel addSubview:infoLabel];
}

-(void)infoPanelDidScroll:(UIScrollView *)scrollView atPoint:(CGPoint)point {
    NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:point];
    infoLabel.text = [NSString stringWithFormat:@"Something about %d", indexPath.row];
}

#pragma mark - Scroll view delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // Store height of indicator
    UIView * indicator = [[self.tableView subviews] lastObject];
    __initalScrollIndicatorHeight = indicator.frame.size.height;
    
    // Starting from beginning
    if ([__infoPanel superview] == nil) {
        // Add it to indicator
        [self moveInfoPanelToIndicatorView];
        
		// Prepare to slide in
        CGRect f = __infoPanel.frame;
        CGRect f2= f;
        f2.origin.x += KNPathTableSlideInOffset;
		[__infoPanel setFrame:f2];
        
        // Fade in and slide left
        [self infoPanelWillAppear:scrollView];
        [UIView animateWithDuration:KNPathTableFadeInDuration
                         animations:^{
                             __infoPanel.alpha = 1;
                             __infoPanel.frame = f;
                         } completion:^(BOOL finished) {
                             [self infoPanelDidAppear:scrollView];
                         }];
	}
    
    // If it is waiting to fade out, then maintain position
    else if ([__infoPanel superview] == self.view) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(slideOutInfoPanel) object:nil];
        [self moveInfoPanelToIndicatorView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UIView * indicator = [[scrollView subviews] lastObject];
    
    // Make sure the panel is visible
    if (__infoPanel.alpha == 0) __infoPanel.alpha = 1;
    
	// Current position is near bottom
	if (indicator.frame.size.height < __initalScrollIndicatorHeight) {
        if (scrollView.contentOffset.y > 0 && [__infoPanel superview] != self.view) {
            // Move panel to a fixed position
            [__infoPanel removeFromSuperview];
            CGRect f = [self.view convertRect:__infoPanel.frame fromView:indicator];
            __infoPanel.frame = CGRectMake(f.origin.x, self.tableView.frame.size.height-f.size.height, f.size.width, f.size.height);
            [self.view addSubview:__infoPanel];
        }
	}
    
    // Return the panel to indicator
    else if ([__infoPanel superview] != indicator) {
        [self moveInfoPanelToIndicatorView];
    }
    
    // The current center of panel
    if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height) {
        [self infoPanelDidScroll:scrollView atPoint:CGPointMake(indicator.center.x,scrollView.contentSize.height-1)];
    } else {
        [self infoPanelDidScroll:scrollView atPoint:indicator.center];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // Remove it from indicator view but maintain position
    if ([__infoPanel superview] != self.view) [self moveInfoPanelToSuperView];
    [self performSelector:@selector(slideOutInfoPanel) withObject:nil afterDelay:KNPathTableFadeOutDelay];
    [self infoPanelDidStopScrolling:scrollView];
}

#pragma mark - Helper methods

-(void)moveInfoPanelToSuperView {
    UIView * indicator = [[self.tableView subviews] lastObject];
    CGRect f = [self.view convertRect:__infoPanel.frame fromView:indicator];
    if ([__infoPanel superview]) [__infoPanel removeFromSuperview];
    __infoPanel.frame = f;
    [self.view addSubview:__infoPanel];
}

-(void)moveInfoPanelToIndicatorView {
    UIView * indicator = [[self.tableView subviews] lastObject];
    CGRect f = __infoPanelInitialFrame;
    f.origin.y = indicator.frame.size.height/2 - f.size.height/2;
    if ([__infoPanel superview]) [__infoPanel removeFromSuperview];
    [indicator addSubview:__infoPanel];
    __infoPanel.frame = f;
}

-(void)slideOutInfoPanel {
    CGRect f = __infoPanel.frame;
    f.origin.x += KNPathTableSlideInOffset;
    [self infoPanelWillDisappear:self.tableView];
    [UIView animateWithDuration:KNPathTableFadeOutDuration
                     animations:^{
                         __infoPanel.alpha = 0;
                         __infoPanel.frame = f;
                     } completion:^(BOOL finished) {
                         [__infoPanel removeFromSuperview];
                         [self infoPanelDidDisappear:self.tableView];
                     }];
}

#pragma mark - Blank implementations

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - Used to be dealloc here

@end
