//
//  ncImageSliderScrollView.h
//  myChildrens
//
//  Created by DuetHealth on 7/29/14.
//
//

#import <UIKit/UIKit.h>

@protocol ncImageSliderScrollViewDelegate<UIScrollViewDelegate>
- (void)sliderImageUpdatedToImageNumber:(NSInteger)imageSequenceNumber;
@end

@interface ncImageSliderScrollView : UIScrollView

@property (nonatomic, assign) NSInteger numberOfImagesOnSliderView;
@property (nonatomic, assign) float slideDuration;
@property (nonatomic, strong) NSString* backArrowImage;
@property (nonatomic, strong) NSString* nextArrowImage;
@property (nonatomic, strong) NSArray* sliderImagesCollection;
@property (nonatomic, assign) NSInteger currentSlideNumber;

//What happens when user clicks back and next buttons on slider
@property (nonatomic, assign) id<ncImageSliderScrollViewDelegate> delegate;

- (void)initWithImages;

- (void)getAdjustedScrollViewXPositionForOffset;
- (void)adjustToCalculatedOffset;
- (void)slideToImageWithSequence:(NSInteger)imageSequence; //Sequence ranges from 0 to size-1

- (void)startAutoSlideShowWithInterval:(NSTimeInterval)autoSlideShowInterval;
- (void)stopAutoSlideShow;
@end
