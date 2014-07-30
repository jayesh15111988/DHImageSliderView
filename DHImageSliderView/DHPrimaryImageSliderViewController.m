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

    //Prevent scroll view from sliding itself to the bottom. Happens only in horizontal scrolling
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //Content offset set to origin - Must be placed in the viewDidAppear
    self.imageSliderScrollView.contentOffset = CGPointMake (0, 0);
}

- (void)addBulletsViewOnScreen {

    //This is the collection of bullet points to make random jumps from one image to another
    self.bulletButtonsView = [[UIView alloc] initWithFrame:CGRectMake (380, 610, 310, 50)];
    [self.bulletButtonsView setBackgroundColor:[UIColor whiteColor]];

    for (NSInteger i = 0; i < NUMBER_OF_IMAGES_ON_SLIDER_VIEW; i++) {

        UIButton* imageSelectorButton = [[UIButton alloc] initWithFrame:CGRectMake (i * 40, 13, 30, 30)];
        [imageSelectorButton setBackgroundImage:[UIImage imageNamed:(!i) ? @"orange_page_indicator.png" : @"gray_page_indicator.png"] forState:UIControlStateNormal];
        imageSelectorButton.tag = i + 1;
        [imageSelectorButton addTarget:self action:@selector (bulletButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.bulletButtonsView addSubview:imageSelectorButton];
    }

    [self.view addSubview:self.bulletButtonsView];
}

- (void)setupSliderImageView {

    //This is necessary in case user manually updated slider images and then we need to update one of the bullet points on the screen which resides in completely different class
    //Add some fancy parameters before actually making view appear on the screen

    self.imageSliderScrollView.delegate = self;
    self.imageSliderScrollView.numberOfImagesOnSliderView = NUMBER_OF_IMAGES_ON_SLIDER_VIEW;
    self.imageSliderScrollView.slideDuration = 0.5f;
    self.imageSliderScrollView.imageSlideDirection = Default;

    //You may do it - If not it will just grab default images from project source.Here goes the fancy stuff you can put

    //          self.imageSliderScrollView.backArrowImage = @"btn_caret_white_left_horizontal.png";
    //          self.imageSliderScrollView.nextArrowImage = @"btn_caret_white_right_horizontal.png";

    NSInteger numberOfTotalImages = self.imageSliderScrollView.numberOfImagesOnSliderView;

    //We collect images and assign to array of image slider class

    NSMutableArray* imagesCollectionToDisplayOnslider = [NSMutableArray array];
    while (numberOfTotalImages) {

        [imagesCollectionToDisplayOnslider addObject:[NSString stringWithFormat:@"img_main_%d.png", numberOfTotalImages--]];
    }

    //This is whole collection of available images that will be shown on current view on screen
    self.imageSliderScrollView.sliderImagesCollection = imagesCollectionToDisplayOnslider;
    [self.imageSliderScrollView initWithImages];

    //shows which bullet button is currenly active
    self.previouslySelectedButtonTagNumber = 1;
}

#pragma mark ImageSliderView delegate method used to update any UI on main screen
- (void)sliderImageUpdatedToImageNumber:(NSInteger)imageSequenceNumber {
    //this is when user instead of scrolling through scroll view, clicks available buttons on the screen. These buttons are nothing but the bullets
    [self resetButtonsWithSequenceNumberandButton:(UIButton*)[self.bulletButtonsView viewWithTag:imageSequenceNumber + 1] toSlide:NO];
}

#pragma mark scrollview delegate methods
- (void)scrollViewDidScroll:(UIScrollView*)scrollView {

    //Call this method when scroll view gets scrolled each time. This will be used to adjust image position once delegate detects it has started
    //To decelerate
    [self.imageSliderScrollView getAdjustedScrollViewXPositionForOffset];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView {

    //Once slided enough - Adjust the position of slider view on the view to make it show one complete image in contrast to two partial images side by side
    [self.imageSliderScrollView adjustToCalculatedOffset];

    //It is because image slider organizes from 0 to max-1 and button tags count from 1 to max.
    [self resetButtonsWithSequenceNumberandButton:(UIButton*)[self.bulletButtonsView viewWithTag:self.imageSliderScrollView.currentSlideNumber + 1] toSlide:NO];
}

- (IBAction)startSlideShowPressed:(id)sender {

    //Auto scroll for a slider view
    [self.imageSliderScrollView startAutoSlideShowWithInterval:(AUTO_SLIDER_TIME_INTERVAL > self.imageSliderScrollView.slideDuration) ? AUTO_SLIDER_TIME_INTERVAL : self.imageSliderScrollView.slideDuration];
}

- (IBAction)stopSlideShow:(id)sender {

    //Stop slider view
    [self.imageSliderScrollView stopAutoSlideShow];
}

- (IBAction)bulletButtonPressed:(id)sender {

    //We have bullets on a view which could be used to control flow of images on screen to jump to and fro between random images
    [self resetButtonsWithSequenceNumberandButton:sender toSlide:YES];
}

- (void)resetButtonsWithSequenceNumberandButton:(UIButton*)pressedButton toSlide:(BOOL)toSlideImageView {

    //Change buttons colors when image switching happends - More fancy(?) stuff

    [(UIButton*)[self.bulletButtonsView viewWithTag:self.previouslySelectedButtonTagNumber] setBackgroundImage:[UIImage imageNamed:@"gray_page_indicator.png"] forState:UIControlStateNormal];
    [pressedButton setBackgroundImage:[UIImage imageNamed:@"orange_page_indicator.png"] forState:UIControlStateNormal];
    self.previouslySelectedButtonTagNumber = pressedButton.tag;

    //Images slide numbers range from 0 to max-1 and tags range from 1 to max

    if (toSlideImageView) {
        [self.imageSliderScrollView slideToImageWithSequence:pressedButton.tag - 1];
    }
}

@end
