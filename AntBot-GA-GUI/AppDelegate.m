#import "AppDelegate.h"
#import "AntBot-GA/GA.h"

NSString *FILE_PATH = @"~/Dropbox/School/Research/AntBot/Data/GA evolved parameters";
int NUM_ITERATIONS = 10;

@implementation AppDelegate

@synthesize simView;

-(void) applicationDidFinishLaunching:(NSNotification *)aNotification
{
    Simulation* sim = [[Simulation alloc] init];
    
    [sim setRobotCount:6];
    [sim setTeamCount:100];
    [sim setGenerationCount:100];
    [sim setTagCount:256];
    [sim setEvaluationCount:1];
    
    [sim setDistributionClustered:0.];
    [sim setDistributionPowerlaw:1.];
    [sim setDistributionRandom:0.];
    
    [sim setPositionalError:0.f];
    [sim setDetectionError:0.f];
    
    [sim setRandomizeParameters:TRUE];
    
    [sim setDelegate:self];
    [sim setTickRate:.005f];
    [sim setViewDelegate:(NSObject*)simView];
    
    [sim setParameterFile:[NSString stringWithFormat:@"%@/parameters.csv",[FILE_PATH stringByExpandingTildeInPath]]];
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        [sim start];
    });
}

@end
