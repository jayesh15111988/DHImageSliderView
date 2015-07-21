//
//  DHPrimaryImageSliderViewController.m
//  DHImageSliderView
//
//  Created by DuetHealth on 7/29/14.
//  Copyright (c) 2014 DuetHealth. All rights reserved.
//

#import "DHPrimaryImageSliderViewController.h"
#import "ncImageSliderScrollView.h"

#define NUMBER_OF_IMAGES_ON_SLIDER_VIEW 8
#define AUTO_SLIDER_TIME_INTERVAL 2.0

@interface DHPrimaryImageSliderViewController ()
@property (strong, nonatomic) IBOutlet ncImageSliderScrollView* imageSliderScrollView;

@end

@implementation DHPrimaryImageSliderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupSliderImageView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // Content offset set to origin - Must be placed in the viewDidAppear.
    self.imageSliderScrollView.contentOffset = CGPointMake (0, 0);
}

- (void)setupSliderImageView {

    //self.imageSliderScrollView.numberOfImagesOnSliderView = NUMBER_OF_IMAGES_ON_SLIDER_VIEW;
    //Animation duration while making transition
    self.imageSliderScrollView.bulletImageSize = CGSizeMake(20, 20);
    self.imageSliderScrollView.slideDuration = 0.5f;
    self.imageSliderScrollView.imageSlideDirection = SlideDirectionHorizontal;
    self.imageSliderScrollView.slidingImagesContentMode = UIViewContentModeScaleAspectFill;
    //Once you swipe, it makes quick transition to other slide
    self.imageSliderScrollView.isContinuousSwipe = NO;
    

    //You may do it - If not it will just grab default images from project source.Here goes the fancy stuff you can put

    // self.imageSliderScrollView.backArrowImage = @"DH_btn_caret_white_left_horizontal.png";
    // self.imageSliderScrollView.nextArrowImage = @"DH_btn_caret_white_right_horizontal.png";

    //Setup bullet images only if you want bullet view to appear on screen
    self.imageSliderScrollView.bulletSelectedImage = @"DH_orange_page_indicator.png";
    self.imageSliderScrollView.bulletDeselectedImage = @"DH_gray_page_indicator.png";
    
    self.imageSliderScrollView.previousNextButtonsFrameSize = CGSizeMake(22, 33);
    self.imageSliderScrollView.transitionStyle = TransitionStyleFade;
    
    NSInteger numberOfTotalImages = NUMBER_OF_IMAGES_ON_SLIDER_VIEW;

    //We collect images and assign to array of image slider class

    NSMutableArray* imagesCollectionToDisplayOnslider = [NSMutableArray array];
    while (numberOfTotalImages) {
        [imagesCollectionToDisplayOnslider addObject:[NSString stringWithFormat:@"DH_img_main_%ld.png", (long)numberOfTotalImages--]];
    }

    //This is whole collection of available images that will be shown on current view on screen
    [self.imageSliderScrollView initAndSetSliderImagesCollection:imagesCollectionToDisplayOnslider];
    UIView* bulletView = [self.imageSliderScrollView bulletPointsViewForImageSlider];
    bulletView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:bulletView];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_imageSliderScrollView]-15-[bulletView(bulletViewHeight)]" options:kNilOptions metrics:@{@"bulletViewHeight": @(bulletView.frame.size.height)} views:NSDictionaryOfVariableBindings(_imageSliderScrollView, bulletView)]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bulletView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:bulletView.frame.size.width]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bulletView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
}

#pragma mark scrollview delegate methods
- (void)scrollViewDidScroll:(UIScrollView*)scrollView {

    //Call this method when scroll view gets scrolled each time. This will be used to adjust image position once delegate detects it has started
    //To decelerate
    [self.imageSliderScrollView adjustedScrollViewXPositionForOffset];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView {

    //Once slided enough - Adjust the position of slider view on the view to make it show one complete image in contrast to two partial images side by side
    [self.imageSliderScrollView adjustToCalculatedOffset];
}

- (IBAction)startSlideShowPressed:(id)sender {

    //Auto scroll for a slider view
    [self.imageSliderScrollView startAutoSlideShowWithInterval:(AUTO_SLIDER_TIME_INTERVAL > self.imageSliderScrollView.slideDuration) ? AUTO_SLIDER_TIME_INTERVAL : self.imageSliderScrollView.slideDuration];
}

- (IBAction)stopSlideShow:(id)sender {

    // Stop slider view.
    [self.imageSliderScrollView stopAutoSlideShow];
}

@end
