#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface SetupController : UIViewController /* Specify a superclass (eg: NSObject or NSView) */ 
{
	IBOutlet id brokerRelationsInput;
	IBOutlet id accountingInput;
	IBOutlet id corpStandingInput;
	IBOutlet id factionStandingInput;
	IBOutlet id profileNameInput;
	
	IBOutlet id hideKeypadButton;
	IBOutlet id nextTextfieldButton;
	
	NSString *profileToEdit;
}

@property (readwrite,assign) NSString *profileToEdit;

- (IBAction)hideKeypad: (id) sender;
- (IBAction)selectNextTextfield: (id) sender;
- (void) showHideKeypadButton: (BOOL) showButton;

- (void) profileNameValueChanged: (id) sender;


- (IBAction) saveChanges: (id)sender;
@end
