#import <Cocoa/Cocoa.h>

@class SimulationView;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property SimulationView* IBOutlet simView;

@end
