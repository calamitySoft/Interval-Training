//
//	Drop-in paging view:
//	Logan Moseley
//
//	Xcode:
//		Declare a PageControlDelegate object in the ViewController interface that wants paging.
//		Setup an IBOutlet property and synthesize for the pageControlDelegate.
//		Invoke [pageControlDelegate initWithStrings:] & [startAtPage:] in viewDidLoad of the ViewController.
//		Declare the ViewController a PageControlDelegateDelegate.
//		Implement the [changedPageTo:] call-back method in the ViewController. Updates the VC on page-change.
//
//	Interface Builder:
//		Place an object in the view nib that wants paging.
//		Make the object's class PageControlDelegate. Link it to the ViewController.
//		Place a UIScrollView and UIPageControl in the nib's View. Link them to PageControlDelegate.
//		Link the PageControlDelegate's delegate to be the ViewController.
//


#import <UIKit/UIKit.h>

@protocol PageControlDelegateDelegate;

@interface PageControlDelegate : NSObject <UIScrollViewDelegate> {
	id <PageControlDelegateDelegate> delegate;

	UIScrollView *scrollView;
	UIPageControl *pageControl;
    NSMutableArray *viewControllers;
	
    // To be used when scrolls originate from the UIPageControl
    BOOL pageControlUsed;
	
	NSArray *optionsStrArray;
	int numberOfPages;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) NSMutableArray *viewControllers;
@property (nonatomic, retain) NSArray *optionsStrArray;

- (void)clearPages;
- (id)initWithStrings:(NSArray*)stringArray;
- (void)startAtPage:(NSUInteger)page;
- (IBAction)changePage:(id)sender;

@end



@protocol PageControlDelegateDelegate
	- (void)changedPageTo:(int)newPage;
@end