//
//  ncImageSliderScrollView.h
//  myChildrens
//
//  Created by DuetHealth on 7/29/14.
//
//

#import <UIKit/UIKit.h>

// We have third type as default which zeroes in on Horizontal scrolling.
typedef enum {
    Horizontal,
    Vertical,
    Default
} SlideDirection;

@interface ncImageSliderScrollView : UIScrollView

@property (assign, nonatomic) CGSize sliderImageFrameSize;
@property (assign, nonatomic) CGSize previousNextButtonsFrameSize;
@property (assign, nonatomic) CGSize bulletImageSize;
@property (nonatomic, assign) CGFloat slideDuration;
@property (nonatomic, strong) NSString* backArrowImage;
@property (nonatomic, strong) NSString* nextArrowImage;
@property (nonatomic, strong) NSArray* sliderImagesCollection;
@property (nonatomic, assign) NSInteger currentSlideNumber;
@property (nonatomic, assign) UIViewContentMode slidingImagesContentMode;

@property (nonatomic, strong) NSString* bulletSelectedImage;
@property (nonatomic, strong) NSString* bulletDeselectedImage;

// Which direction view should scroll? - Vertical or Horizontal.
@property (nonatomic, assign) SlideDirection imageSlideDirection;

// Continuous or step swipe when user swipes his fingers over the screen.
// Default is step swip mode.

@property (assign, nonatomic) BOOL isContinuousSwipe;

- (void)initAndSetSliderImagesCollection:(NSArray*)sliderImageNamesCollection;
- (void)adjustedScrollViewXPositionForOffset;
- (void)adjustToCalculatedOffset;

- (void)startAutoSlideShowWithInterval:(NSTimeInterval)autoSlideShowInterval;
- (void)stopAutoSlideShow;

- (UIView*)bulletPointsViewForImageSlider;
@end
