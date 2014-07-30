//
//  ncImageSliderScrollView.h
//  myChildrens
//
//  Created by DuetHealth on 7/29/14.
//
//

#import <UIKit/UIKit.h>

@protocol ncImageSliderScrollViewDelegate<UIScrollViewDelegate>
@optional
- (void)sliderImageUpdatedToImageNumber:(NSInteger)imageSequenceNumber;
@end

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

//Which direction view should scroll?
@property (nonatomic, assign) SlideDirection imageSlideDirection;

//What happens when user clicks back and next buttons on slider
@property (nonatomic, assign) id<ncImageSliderScrollViewDelegate> delegate;

- (void)initWithImages;

- (void)getAdjustedScrollViewXPositionForOffset;
- (void)adjustToCalculatedOffset;
- (void)slideToImageWithSequence:(NSInteger)imageSequence; //Sequence ranges from 0 to size-1

- (void)startAutoSlideShowWithInterval:(NSTimeInterval)autoSlideShowInterval;
- (void)stopAutoSlideShow;
@end
