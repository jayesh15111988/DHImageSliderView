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
@property (nonatomic, assign) NSInteger widthOfSingleImage;
@property (nonatomic, assign) NSInteger offsetToAdjustImageSliderTo;
@property (nonatomic, strong) NSTimer* pulseTimer;
@property (nonatomic, strong) UIButton* backArrow;
@property (nonatomic, strong) UIButton* frontArrow;

@end

@implementation ncImageSliderScrollView

- (void)initWithImages {

    self.imagesCollection = [NSMutableArray array];
    self.offsetToAdjustImageSliderTo = 0.0;

    //Default duration  - Could be changed programmatically
    self.slideDuration = self.slideDuration ?: 0.5f;

    self.widthOfSingleImage = self.frame.size.width;
    float xPositionOfImage = 0;

    //Add input images to scroll view one by one
    for (NSString* individualSliderImage in self.sliderImagesCollection) {

        UIImageView* imageViewToAddToSliderView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:individualSliderImage]];
        [imageViewToAddToSliderView sizeToFit];

        imageViewToAddToSliderView.frame = CGRectMake (xPositionOfImage, imageViewToAddToSliderView.frame.origin.y, self.frame.size.width, self.frame.size.height);
        xPositionOfImage += self.widthOfSingleImage; // Adding some gutter between image if possible putting 0.0 for time being

        self.contentSize = imageViewToAddToSliderView.frame.size;

        [self addSubview:imageViewToAddToSliderView];
    }

    self.contentSize = CGSizeMake (self.numberOfImagesOnSliderView * self.frame.size.width, 0);

    self.backArrow = [[UIButton alloc] initWithFrame:CGRectMake (30, (self.frame.size.height / 2) - 33, 20, 33)];
    [self.backArrow setBackgroundImage:[UIImage imageNamed:self.backArrowImage] forState:UIControlStateNormal];
    [self.backArrow addTarget:self action:@selector (showPreviousImage:) forControlEvents:UIControlEventTouchUpInside];

    self.frontArrow = [[UIButton alloc] initWithFrame:CGRectMake (self.frame.size.width - 50, (self.frame.size.height / 2) - 33, 20, 33)];
    [self.frontArrow setBackgroundImage:[UIImage imageNamed:self.nextArrowImage] forState:UIControlStateNormal];
    [self.frontArrow addTarget:self action:@selector (showNextImage:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:self.frontArrow];
    [self addSubview:self.backArrow];
}

- (IBAction)showPreviousImage:(id)sender {

    //If only not very first image
    if (self.offsetToAdjustImageSliderTo) {

        [self makeTransitionToOffset:self.offsetToAdjustImageSliderTo - self.widthOfSingleImage];
    } else {

        [self makeTransitionToOffset:self.widthOfSingleImage * (self.numberOfImagesOnSliderView - 1)];
    }
    [self.delegate sliderImageUpdatedToImageNumber:self.currentSlideNumber];
}

- (IBAction)showNextImage:(id)sender {

    if (self.offsetToAdjustImageSliderTo < ((self.numberOfImagesOnSliderView - 1) * self.widthOfSingleImage)) {

        [self makeTransitionToOffset:self.offsetToAdjustImageSliderTo + self.widthOfSingleImage];
    } else {

        [self makeTransitionToOffset:0.0];
    }

    [self.delegate sliderImageUpdatedToImageNumber:self.currentSlideNumber];
}

- (void)adjustToCalculatedOffset {

    [self makeTransitionToOffset:self.offsetToAdjustImageSliderTo];
}

- (void)slideToImageWithSequence:(NSInteger)imageSequence {

    [self makeTransitionToOffset:self.widthOfSingleImage * imageSequence];
}
- (void)getAdjustedScrollViewXPositionForOffset {

    self.currentSlideNumber = (NSInteger)round (self.contentOffset.x / self.widthOfSingleImage);
    self.offsetToAdjustImageSliderTo = self.currentSlideNumber * self.widthOfSingleImage;

    self.backArrow.frame = CGRectMake (self.contentOffset.x + 30, self.backArrow.frame.origin.y, 20, 33);

    self.frontArrow.frame = CGRectMake (self.contentOffset.x + self.frame.size.width - 50, self.frontArrow.frame.origin.y, 20, 33);
}

//X only cause we are sliding it down horizontally - TO DO in future - make it supportive for vertical sliding too
- (void)makeTransitionToOffset:(float)xOffsetValue {

    [UIView transitionWithView:nil
                      duration:self.slideDuration
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        
                
                        self.contentOffset = CGPointMake(xOffsetValue,self.contentOffset.y);
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
