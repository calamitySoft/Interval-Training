//
//	Drop-in paging view:
//	Logan Moseley
//
//	Xcode:
//		Declare a PageControlDelegate in the ViewController interface that wants paging.
//		Setup an IBOutlet property and synthesize for the pageControlDelegate.
//		Invoke [pageControlDelegate init] in viewDidLoad of the ViewController.
//
//	Interface Builder:
//		Place an object in the view nib that wants paging.
//		Make the object's class PageControlDelegate. Link it to the ViewController.
//		Place a UIScrollView and UIPageControl in the nib's View. Link them to PageControlDelegate.
//


#import <UIKit/UIKit.h>

@interface PageControlDelegate : NSObject <UIScrollViewDelegate> {
	UIScrollView *scrollView;
	UIPageControl *pageControl;
    NSMutableArray *viewControllers;
	
    // To be used when scrolls originate from the UIPageControl
    BOOL pageControlUsed;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) NSMutableArray *viewControllers;

- (id)init;
- (IBAction)changePage:(id)sender;

@end
