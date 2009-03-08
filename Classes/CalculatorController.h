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
	
	IBOutlet UIWebView *webView;
	
	float brokersFee;
	float salesTax;
	
}

- (IBAction)doCalc:(id)sender;

- (IBAction)hideKeypad: (id) sender;
- (IBAction)selectNextTextfield: (id) sender;
- (void) showHideKeypadButton: (BOOL) showButton;

- (void) updateLabels;

@end
