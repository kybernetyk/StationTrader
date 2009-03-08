#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface SetupController : UIViewController /* Specify a superclass (eg: NSObject or NSView) */ 
{
	IBOutlet id brokerRelationsInput;
	IBOutlet id accountingInput;
	IBOutlet id corpStandingInput;
	IBOutlet id factionStandingInput;
	
	IBOutlet id hideKeypadButton;
	IBOutlet id nextTextfieldButton;
}

- (IBAction)hideKeypad: (id) sender;
- (IBAction)selectNextTextfield: (id) sender;
- (void) showHideKeypadButton: (BOOL) showButton;

- (IBAction) saveChanges: (id)sender;
@end
