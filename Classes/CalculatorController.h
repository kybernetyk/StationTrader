#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface CalculatorController : UIViewController /* Specify a superclass (eg: NSObject or NSView) */ 
{
	IBOutlet id activeProfileLabel;
	IBOutlet id salesTaxLabel;
	IBOutlet id brokersFeeLabel;
	IBOutlet id buyPriceInput;
    IBOutlet id sellPriceInput;
	IBOutlet id calcButton;
	IBOutlet id hideKeypadButton;
	IBOutlet id nextTextfieldButton;
	IBOutlet id unitsTextField;
	
	IBOutlet UIWebView *webView;

#ifdef CUSTOM_KEYBOARD
	UIButton *dot;
#endif
	
	float brokersFee;
	float salesTax;

	
	UITextField *currentTextField;
}

@property (nonatomic, retain) UIButton *dot;

- (IBAction)doCalc:(id)sender;

- (IBAction)hideKeypad: (id) sender;
- (IBAction)selectNextTextfield: (id) sender;
- (void) showHideKeypadButton: (BOOL) showButton;

- (void) updateLabels;

@end
