//
//  ncImageSliderScrollView.h
//  myChildrens
//
//  Created by DuetHealth on 7/29/14.
//
//

#import <UIKit/UIKit.h>

//We have third type as default which zeroes in on Horizontal scrolling
typedef enum {
    Horizontal,
    Vertical,
    Default
} SlideDirection;

@interface ncImageSliderScrollView : UIScrollView

@property (nonatomic, assign) NSInteger numberOfImagesOnSliderView;
@property (nonatomic, assign) float slideDuration;
@property (nonatomic, strong) NSString* backArrowImage;
@property (nonatomic, strong) NSString* nextArrowImage;
@property (nonatomic, strong) NSArray* sliderImagesCollection;
@property (nonatomic, assign) NSInteger currentSlideNumber;

@property (nonatomic, strong) NSString* bulletSelectedImage;
@property (nonatomic, strong) NSString* bulletDeselectedImage;

//Which direction view should scroll? - Vertical or Horizontal
@property (nonatomic, assign) SlideDirection imageSlideDirection;

//Continuous or step swipe when user swipes his fingers over the screen
//Default is step swip mode
@property (assign, nonatomic) BOOL isConinuousSwipe;

- (void)initWithImages;

- (void)getAdjustedScrollViewXPositionForOffset;
- (void)adjustToCalculatedOffset;

- (void)startAutoSlideShowWithInterval:(NSTimeInterval)autoSlideShowInterval;
- (void)stopAutoSlideShow;

- (UIView*)getBulletPointsViewForImageSliderWithSize:(CGRect)bulletViewFrameSize;
@end
