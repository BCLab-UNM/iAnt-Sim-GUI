#import "AppDelegate.h"
#import "AntBot-GA/GA.h"

@implementation AppDelegate

@synthesize simView;

-(void) applicationDidFinishLaunching:(NSNotification *)aNotification
{
    Simulation* sim = [[Simulation alloc] init];
    [sim setRobotCount:6];
    [sim setTeamCount:100];
    [sim setDistributionClustered:0.];
    [sim setDistributionPowerlaw:1.];
    [sim setDistributionRandom:0.];
    [sim setGenerationCount:100];
    [sim setTagCount:256];
    [sim setRandomizeParameters:TRUE];
    [sim setDelegate:self];
    [sim setTickRate:.005f];
    [sim setViewDelegate:(NSObject*)simView];
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        [sim start];
    });
}

@end
