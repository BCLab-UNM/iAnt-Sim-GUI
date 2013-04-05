#import "AppDelegate.h"

NSString *FILE_PATH = @"~/Desktop";
int NUM_ITERATIONS = 10;

@implementation AppDelegate

@synthesize simView;

-(void) applicationDidFinishLaunching:(NSNotification *)aNotification
{
    Simulation* simulation = [[Simulation alloc] init];
    
    [simulation setRobotCount:6];
    [simulation setTeamCount:100];
    [simulation setGenerationCount:100];
    [simulation setTagCount:256];
    [simulation setEvaluationCount:1];
    
    [simulation setDistributionClustered:0.];
    [simulation setDistributionPowerlaw:1.];
    [simulation setDistributionRandom:0.];
    
    [simulation setPositionalError:0.f];
    [simulation setDetectionError:0.f];
    
    [simulation setRandomizeParameters:TRUE];
    
    [simulation setTagFractionCutoff:1.];
    
    [simulation setDelegate:self];
    [simulation setTickRate:.005f];
    [simulation setViewDelegate:(NSObject*)simView];
    
    [simulation setParameterFile:[NSString stringWithFormat:@"%@/parameters.csv",[FILE_PATH stringByExpandingTildeInPath]]];
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        [simulation start];
    });
}

@end
