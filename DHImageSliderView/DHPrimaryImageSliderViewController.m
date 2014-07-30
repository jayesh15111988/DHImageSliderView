//
//  DHPrimaryImageSliderViewController.m
//  DHImageSliderView
//
//  Created by DuetHealth on 7/29/14.
//  Copyright (c) 2014 DuetHealth. All rights reserved.
//

#import "DHPrimaryImageSliderViewController.h"

#define NUMBER_OF_IMAGES_ON_SLIDER_VIEW 8
#define AUTO_SLIDER_TIME_INTERVAL 2.0

@interface DHPrimaryImageSliderViewController ()
@property (strong, nonatomic) IBOutlet ncImageSliderScrollView* imageSliderScrollView;
@property (strong, nonatomic) UIView* bulletButtonsView;
@property (assign, nonatomic) NSInteger previouslySelectedButtonTagNumber;

@end

@implementation DHPrimaryImageSliderViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupSliderImageView];
    [self addBulletsViewOnScreen];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.imageSliderScrollView.contentOffset = CGPointMake (0, 0);
}

- (void)addBulletsViewOnScreen {

    self.bulletButtonsView = [[UIView alloc] initWithFrame:CGRectMake (380, 610, 310, 50)];
    [self.bulletButtonsView setBackgroundColor:[UIColor whiteColor]];

    for (NSInteger i = 0; i < NUMBER_OF_IMAGES_ON_SLIDER_VIEW; i++) {

        UIButton* imageSelectorButton = [[UIButton alloc] initWithFrame:CGRectMake (i * 40, 13, 30, 30)];
        [imageSelectorButton setBackgroundImage:[UIImage imageNamed:(i == 0) ? @"orange_page_indicator.png" : @"gray_page_indicator.png"] forState:UIControlStateNormal];
        imageSelectorButton.tag = i + 1;
        [imageSelectorButton addTarget:self action:@selector (bulletButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.bulletButtonsView addSubview:imageSelectorButton];
    }

    [self.view addSubview:self.bulletButtonsView];
}

- (void)setupSliderImageView {

    //In here setup your images - For time being, images are fixed in position on screen. You may not move them

    //This is necessary in case user manually updated slider images and then we need to update one of the bullet points on the screen which resides in completely different class

    self.imageSliderScrollView.delegate = self;
    self.imageSliderScrollView.numberOfImagesOnSliderView = NUMBER_OF_IMAGES_ON_SLIDER_VIEW;
    self.imageSliderScrollView.slideDuration = 0.5f;

    self.imageSliderScrollView.imageSlideDirection = Vertical;

    //Prevent scroll view from sliding itself to the bottom. Happens only in horizontal scrolling

    //You may do it - If not it will just grab default images from project source.

    //          self.imageSliderScrollView.backArrowImage = @"btn_caret_white_left_horizontal.png";
    //          self.imageSliderScrollView.nextArrowImage = @"btn_caret_white_right_horizontal.png";

    NSInteger numberOfTotalImages = self.imageSliderScrollView.numberOfImagesOnSliderView;

    //We collec images and assign to array in image slider controller

    NSMutableArray* imagesCollectionToDisplayOnslider = [NSMutableArray array];
    while (numberOfTotalImages) {

        [imagesCollectionToDisplayOnslider addObject:[NSString stringWithFormat:@"img_main_%d.png", numberOfTotalImages--]];
    }

    //This is whole collection of available images that will be shown on current view on screen
    self.imageSliderScrollView.sliderImagesCollection = imagesCollectionToDisplayOnslider;
    [self.imageSliderScrollView initWithImages];

    self.previouslySelectedButtonTagNumber = 1; //self.initialButtonForImageSelection;
}

- (void)sliderImageUpdatedToImageNumber:(NSInteger)imageSequenceNumber {
    //this is when user instead of scrolling through scroll view, clicks available buttons on the screen. These buttons are nothing but the bullets
    [self resetButtonsWithSequenceNumberandButton:(UIButton*)[self.bulletButtonsView viewWithTag:imageSequenceNumber + 1] toSlide:NO];
}

#pragma scrollview delegate methods
- (void)scrollViewDidScroll:(UIScrollView*)scrollView {
    //Call this method when scroll view gets scrolled each time

    [self.imageSliderScrollView getAdjustedScrollViewXPositionForOffset];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView {

    //Once slided enough - Adjust the position of slider view on the view to make it show one complete available image
    [self.imageSliderScrollView adjustToCalculatedOffset];

    //It is becasue image slider organizes from 0 and we do from 1. Just add one to the count
    [self resetButtonsWithSequenceNumberandButton:(UIButton*)[self.bulletButtonsView viewWithTag:self.imageSliderScrollView.currentSlideNumber + 1] toSlide:NO];
}

- (IBAction)startSlideShowPressed:(id)sender {
    //Auto scroll of a slider view
    [self.imageSliderScrollView startAutoSlideShowWithInterval:(AUTO_SLIDER_TIME_INTERVAL > self.imageSliderScrollView.slideDuration) ? AUTO_SLIDER_TIME_INTERVAL : self.imageSliderScrollView.slideDuration];
}

- (IBAction)stopSlideShow:(id)sender {
    //Stop slider view
    [self.imageSliderScrollView stopAutoSlideShow];
}

- (IBAction)bulletButtonPressed:(id)sender {
    [self resetButtonsWithSequenceNumberandButton:sender toSlide:YES];
}

- (void)resetButtonsWithSequenceNumberandButton:(UIButton*)pressedButton toSlide:(BOOL)toSlideImageView {

    [(UIButton*)[self.bulletButtonsView viewWithTag:self.previouslySelectedButtonTagNumber] setBackgroundImage:[UIImage imageNamed:@"gray_page_indicator.png"] forState:UIControlStateNormal];
    [pressedButton setBackgroundImage:[UIImage imageNamed:@"orange_page_indicator.png"] forState:UIControlStateNormal];
    self.previouslySelectedButtonTagNumber = pressedButton.tag;

    //Images slide numbers range from 0 to max-1 - Just subtract 1 from count
    if (toSlideImageView) {
        [self.imageSliderScrollView slideToImageWithSequence:pressedButton.tag - 1];
    }
}

@end
