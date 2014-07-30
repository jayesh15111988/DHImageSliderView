//
//  ncImageSliderScrollView.m
//  myChildrens
//
//  Created by DuetHealth on 7/29/14.
//
//

#import "ncImageSliderScrollView.h"

@interface ncImageSliderScrollView ()

@property (nonatomic, strong) NSMutableArray* imagesCollection;
@property (nonatomic, assign) NSInteger lengthOfDesiredImageDimension;
@property (nonatomic, assign) NSInteger offsetToAdjustImageSliderTo;
@property (nonatomic, strong) NSTimer* pulseTimer;
@property (nonatomic, strong) UIButton* backArrow;
@property (nonatomic, strong) UIButton* frontArrow;
@property (nonatomic, assign) BOOL isVerticalSliding;
@property (nonatomic, strong) UIView* bulletButtonsView;
@property (nonatomic, assign) NSInteger previouslySelectedButtonTagNumber;

//Height and width of Frame;
@property (nonatomic, assign) float frameWidth;
@property (nonatomic, assign) float frameHeight;

@end

@implementation ncImageSliderScrollView

- (void)initWithImages {

    //Settting for given scroll view
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;

    //These are collection of images given to the view
    self.imagesCollection = [NSMutableArray array];

    //Set offset to origin
    self.offsetToAdjustImageSliderTo = 0.0;

    //Default duration  - Could be changed programmatically
    self.slideDuration = self.slideDuration ?: 0.5f;
    self.frameWidth = self.frame.size.width;
    self.frameHeight = self.frame.size.height;

    //What should be direction of image scroll?
    self.isVerticalSliding = (self.imageSlideDirection == Vertical);

    //Image dimension offset each time view is scrolled
    self.lengthOfDesiredImageDimension = (self.isVerticalSliding) ? self.frame.size.height : self.frame.size.width;

    //Original position of an image
    float positionOfImage = 0.0f;

    //Add input images to scroll view one by one
    for (NSString* individualSliderImage in self.sliderImagesCollection) {

        UIImageView* imageViewToAddToSliderView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:individualSliderImage]];
        [imageViewToAddToSliderView sizeToFit];

        //Horizontal bouncing - No for vertical scrolling and vice versa

        self.alwaysBounceHorizontal = !self.isVerticalSliding;
        self.alwaysBounceVertical = self.isVerticalSliding;

        if (self.isVerticalSliding) {

            imageViewToAddToSliderView.frame = CGRectMake (imageViewToAddToSliderView.frame.origin.x, positionOfImage, self.frameWidth, self.frameHeight);

        } else {

            imageViewToAddToSliderView.frame = CGRectMake (positionOfImage, imageViewToAddToSliderView.frame.origin.y, self.frameWidth, self.frameHeight);
        }
        positionOfImage += self.lengthOfDesiredImageDimension; // Adding some gutter between image if possible putting 0.0 for time being

        //  self.contentSize = imageViewToAddToSliderView.frame.size;

        [self addSubview:imageViewToAddToSliderView];
    }

    //Set appropriate content size to allow smooth scrolling between max and min images
    self.contentSize = self.isVerticalSliding ? CGSizeMake (0, self.numberOfImagesOnSliderView * self.frameHeight) : CGSizeMake (self.numberOfImagesOnSliderView * self.frameWidth, 0);

    //Customzing next and previous images arrows on screen. If none given, takes default images from project source

    if (self.isVerticalSliding) {

        if (!self.backArrowImage || !self.nextArrowImage) {
            self.backArrowImage = @"DH_btn_caret_white_top_vertical.png";
            self.nextArrowImage = @"DH_btn_caret_white_bottom_vertical.png";
        }

        self.backArrow = [[UIButton alloc] initWithFrame:CGRectMake ((self.frameWidth / 2) - 20, 30, 33, 20)];
        self.frontArrow = [[UIButton alloc] initWithFrame:CGRectMake ((self.frameWidth / 2) - 20, self.frameHeight - 50, 33, 20)];

    } else {
        if (!self.backArrowImage || !self.nextArrowImage) {
            self.backArrowImage = @"DH_btn_caret_white_left_horizontal.png";
            self.nextArrowImage = @"DH_btn_caret_white_right_horizontal.png";
        }
        self.backArrow = [[UIButton alloc] initWithFrame:CGRectMake (30, (self.frameHeight / 2) - 17, 20, 33)];
        self.frontArrow = [[UIButton alloc] initWithFrame:CGRectMake (self.frameWidth - 50, (self.frameHeight / 2) - 17, 20, 33)];
    }

    [self.backArrow setBackgroundImage:[UIImage imageNamed:self.backArrowImage] forState:UIControlStateNormal];
    [self.backArrow addTarget:self action:@selector (showPreviousImage:) forControlEvents:UIControlEventTouchUpInside];

    [self.frontArrow setBackgroundImage:[UIImage imageNamed:self.nextArrowImage] forState:UIControlStateNormal];
    [self.frontArrow addTarget:self action:@selector (showNextImage:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:self.frontArrow];
    [self addSubview:self.backArrow];
    self.previouslySelectedButtonTagNumber = 1;
}

- (IBAction)showPreviousImage:(id)sender {

    if (self.offsetToAdjustImageSliderTo) {
        //Image other than first one
        [self makeTransitionToOffset:self.offsetToAdjustImageSliderTo - self.lengthOfDesiredImageDimension];
    } else {
        //If this is very first image and we want to go to previous image. In this case we will scroll to last image on the view
        [self makeTransitionToOffset:self.lengthOfDesiredImageDimension * (self.numberOfImagesOnSliderView - 1)];
    }
}

- (IBAction)showNextImage:(id)sender {

    if (self.offsetToAdjustImageSliderTo < ((self.numberOfImagesOnSliderView - 1) * self.lengthOfDesiredImageDimension)) {
        //Any image other than last one on the view
        [self makeTransitionToOffset:self.offsetToAdjustImageSliderTo + self.lengthOfDesiredImageDimension];
    } else {
        //If this is very last image and we want to go to next image. In this case we will scroll to first image on the view
        [self makeTransitionToOffset:0.0];
    }
}

- (void)adjustToCalculatedOffset {
    //Adjust image so that it will show full single image instead of two partial images on the screen
    [self makeTransitionToOffset:self.offsetToAdjustImageSliderTo];
}

- (void)slideToImageWithSequence:(NSInteger)imageSequence {
    //Manually sliding images. Range from 0 to max-1
    [self makeTransitionToOffset:self.lengthOfDesiredImageDimension * imageSequence];
}
- (void)getAdjustedScrollViewXPositionForOffset {

    self.currentSlideNumber = (NSInteger)round (((self.isVerticalSliding) ? self.contentOffset.y : self.contentOffset.x) / self.lengthOfDesiredImageDimension);
    self.offsetToAdjustImageSliderTo = self.currentSlideNumber * self.lengthOfDesiredImageDimension;

    if (self.isVerticalSliding) {
        self.backArrow.frame = CGRectMake (self.backArrow.frame.origin.x, self.contentOffset.y + 20, 33, 20);
        self.frontArrow.frame = CGRectMake (self.frontArrow.frame.origin.x, self.contentOffset.y + self.frame.size.height - 50, 33, 20);
    } else {
        self.backArrow.frame = CGRectMake (self.contentOffset.x + 30, self.backArrow.frame.origin.y, 20, 33);
        self.frontArrow.frame = CGRectMake (self.contentOffset.x + self.frame.size.width - 50, self.frontArrow.frame.origin.y, 20, 33);
    }
}

- (void)makeTransitionToOffset:(float)offsetSlideValue {

    [UIView transitionWithView:nil
                      duration:self.slideDuration
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        
                
                        self.contentOffset =self.isVerticalSliding? CGPointMake(0,offsetSlideValue):CGPointMake(offsetSlideValue,0);
                        [self updateBulletPointsWithSelectedButton:(UIButton*)[self.bulletButtonsView viewWithTag:self.currentSlideNumber + 1]];
                    }
                    completion:NULL];
}

//For auto slide show
- (void)startAutoSlideShowWithInterval:(NSTimeInterval)autoSlideShowInterval {

    if (![self.pulseTimer isValid]) {
        self.pulseTimer = [NSTimer scheduledTimerWithTimeInterval:autoSlideShowInterval target:self selector:@selector (showNextImage:) userInfo:nil repeats:YES];

        [self.pulseTimer fire];
    }
}

//Stop the auto slide show on the screen
- (void)stopAutoSlideShow {
    if ([self.pulseTimer isValid]) {
        [self.pulseTimer invalidate];
    }
}

//Bullet point view which will allow user to jump from one image to another
- (UIView*)getBulletPointsViewForImageSliderWithSize:(CGRect)bulletViewFrameSize {
    //This is the collection of bullet points to make random jumps from one image to another
    //User do not wish to initialize this view on his own - We will take care of it

    if (bulletViewFrameSize.origin.x == -1) {

        NSInteger maximumWidthOfBulletView = 40 * self.numberOfImagesOnSliderView;
        CGRect customFrameForBulletView = CGRectMake ((self.frame.origin.x + (self.frame.size.width / 2) - (maximumWidthOfBulletView / 2)), self.frame.origin.y + 20 + self.frame.size.height, maximumWidthOfBulletView, 50);

        self.bulletButtonsView = [[UIView alloc] initWithFrame:customFrameForBulletView];
    } else {
        self.bulletButtonsView = [[UIView alloc] initWithFrame:bulletViewFrameSize];
    }
    [self.bulletButtonsView setBackgroundColor:[UIColor whiteColor]];

    for (NSInteger i = 0; i < self.numberOfImagesOnSliderView; i++) {

        UIButton* imageSelectorButton = [[UIButton alloc] initWithFrame:CGRectMake (i * 40, 13, 30, 30)];
        [imageSelectorButton setBackgroundImage:[UIImage imageNamed:(!i) ? self.bulletSelectedImage : self.bulletDeselectedImage] forState:UIControlStateNormal];
        imageSelectorButton.tag = i + 1;
        [imageSelectorButton addTarget:self action:@selector (bulletButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.bulletButtonsView addSubview:imageSelectorButton];
    }
    return self.bulletButtonsView;
}

- (IBAction)bulletButtonPressed:(UIButton*)sender {

    [self updateBulletPointsWithSelectedButton:sender];
    [self slideToImageWithSequence:sender.tag - 1];
}

- (void)updateBulletPointsWithSelectedButton:(UIButton*)clickedButton {
    [(UIButton*)[self.bulletButtonsView viewWithTag:self.previouslySelectedButtonTagNumber] setBackgroundImage:[UIImage imageNamed:self.bulletDeselectedImage] forState:UIControlStateNormal];
    [clickedButton setBackgroundImage:[UIImage imageNamed:self.bulletSelectedImage] forState:UIControlStateNormal];
    self.previouslySelectedButtonTagNumber = clickedButton.tag;
}

@end
