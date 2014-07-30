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

//Height and width of Frame;
@property (nonatomic, assign) float frameWidth;
@property (nonatomic, assign) float frameHeight;

@end

@implementation ncImageSliderScrollView

- (void)initWithImages {

    self.imagesCollection = [NSMutableArray array];
    self.offsetToAdjustImageSliderTo = 0.0;

    //Default duration  - Could be changed programmatically
    self.slideDuration = self.slideDuration ?: 0.5f;
    self.frameWidth = self.frame.size.width;
    self.frameHeight = self.frame.size.height;

    self.isVerticalSliding = (self.imageSlideDirection == Vertical);

    self.lengthOfDesiredImageDimension = (self.isVerticalSliding) ? self.frame.size.height : self.frame.size.width;
    float positionOfImage = 0.0f;

    //Add input images to scroll view one by one
    for (NSString* individualSliderImage in self.sliderImagesCollection) {

        UIImageView* imageViewToAddToSliderView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:individualSliderImage]];
        [imageViewToAddToSliderView sizeToFit];

        self.alwaysBounceHorizontal = !self.isVerticalSliding;
        self.alwaysBounceVertical = self.isVerticalSliding;

        if (self.isVerticalSliding) {

            imageViewToAddToSliderView.frame = CGRectMake (imageViewToAddToSliderView.frame.origin.x, positionOfImage, self.frameWidth, self.frameHeight);

        } else {

            imageViewToAddToSliderView.frame = CGRectMake (positionOfImage, imageViewToAddToSliderView.frame.origin.y, self.frameWidth, self.frameHeight);
        }
        positionOfImage += self.lengthOfDesiredImageDimension; // Adding some gutter between image if possible putting 0.0 for time being

        self.contentSize = imageViewToAddToSliderView.frame.size;

        [self addSubview:imageViewToAddToSliderView];
    }

    self.contentSize = self.isVerticalSliding ? CGSizeMake (0, self.numberOfImagesOnSliderView * self.frameHeight) : CGSizeMake (self.numberOfImagesOnSliderView * self.frameWidth, 0);

    if (self.isVerticalSliding) {

        if (!self.backArrowImage || !self.nextArrowImage) {
            self.backArrowImage = @"btn_caret_white_top_vertical.png";
            self.nextArrowImage = @"btn_caret_white_bottom_vertical.png";
        }

        self.backArrow = [[UIButton alloc] initWithFrame:CGRectMake ((self.frameWidth / 2) - 20, 30, 33, 20)];
        self.frontArrow = [[UIButton alloc] initWithFrame:CGRectMake ((self.frameWidth / 2) - 20, self.frameHeight - 50, 33, 20)];

    } else {
        if (!self.backArrowImage || !self.nextArrowImage) {
            self.backArrowImage = @"btn_caret_white_left_horizontal.png";
            self.nextArrowImage = @"btn_caret_white_right_horizontal.png";
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
}

- (IBAction)showPreviousImage:(id)sender {

    //If only not very first image
    if (self.offsetToAdjustImageSliderTo) {

        [self makeTransitionToOffset:self.offsetToAdjustImageSliderTo - self.lengthOfDesiredImageDimension];
    } else {

        [self makeTransitionToOffset:self.lengthOfDesiredImageDimension * (self.numberOfImagesOnSliderView - 1)];
    }

    if ([self.delegate respondsToSelector:@selector (sliderImageUpdatedToImageNumber:)]) {
        [self.delegate sliderImageUpdatedToImageNumber:self.currentSlideNumber];
    } else {
        NSLog (@"NO Delegate setup for protocol sliderImageUpdatedToImageNumber"
               @"please implement delegate protocol in the method you are calling this class from ");
    }
}

- (IBAction)showNextImage:(id)sender {

    if (self.offsetToAdjustImageSliderTo < ((self.numberOfImagesOnSliderView - 1) * self.lengthOfDesiredImageDimension)) {

        [self makeTransitionToOffset:self.offsetToAdjustImageSliderTo + self.lengthOfDesiredImageDimension];
    } else {

        [self makeTransitionToOffset:0.0];
    }

    if ([self.delegate respondsToSelector:@selector (sliderImageUpdatedToImageNumber:)]) {
        [self.delegate sliderImageUpdatedToImageNumber:self.currentSlideNumber];
    } else {
        NSLog (@"NO Delegate setup for protocol sliderImageUpdatedToImageNumber"
               @"please implement delegate protocol in the method you are calling this class from ");
    }
}

- (void)adjustToCalculatedOffset {

    [self makeTransitionToOffset:self.offsetToAdjustImageSliderTo];
}

- (void)slideToImageWithSequence:(NSInteger)imageSequence {

    [self makeTransitionToOffset:self.lengthOfDesiredImageDimension * imageSequence];
}
- (void)getAdjustedScrollViewXPositionForOffset {

    //      self.contentOffset=CGPointMake(self.contentOffset.x, 0);
    self.currentSlideNumber = (NSInteger)round (((self.isVerticalSliding) ? self.contentOffset.y : self.contentOffset.x) / self.lengthOfDesiredImageDimension);
    self.offsetToAdjustImageSliderTo = self.currentSlideNumber * self.lengthOfDesiredImageDimension;
    //self.contentOffset.y = 0.0;

    //    NSLog (@"%f adjusted y offset for an image", self.contentOffset.y);

    if (self.isVerticalSliding) {
        self.backArrow.frame = CGRectMake (self.backArrow.frame.origin.x, self.contentOffset.y + 20, 33, 20);
        self.frontArrow.frame = CGRectMake (self.frontArrow.frame.origin.x, self.contentOffset.y + self.frame.size.height - 50, 33, 20);
    } else {
        self.backArrow.frame = CGRectMake (self.contentOffset.x + 30, self.backArrow.frame.origin.y, 20, 33);
        self.frontArrow.frame = CGRectMake (self.contentOffset.x + self.frame.size.width - 50, self.frontArrow.frame.origin.y, 20, 33);
    }
}

//X only cause we are sliding it down horizontally - TO DO in future - make it supportive for vertical sliding too
- (void)makeTransitionToOffset:(float)offsetValue {

    //    NSLog (@"Making transition to offset %f", self.contentOffset.y);

    [UIView transitionWithView:nil
                      duration:self.slideDuration
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        
                
                        self.contentOffset =self.isVerticalSliding? CGPointMake(0,offsetValue):CGPointMake(offsetValue,0);
                    }
                    completion:NULL];
}

- (void)startAutoSlideShowWithInterval:(NSTimeInterval)autoSlideShowInterval {

    self.pulseTimer = [NSTimer scheduledTimerWithTimeInterval:autoSlideShowInterval target:self selector:@selector (showNextImage:) userInfo:nil repeats:YES];

    [self.pulseTimer fire];
}
- (void)stopAutoSlideShow {
    [self.pulseTimer invalidate];
}

@end
