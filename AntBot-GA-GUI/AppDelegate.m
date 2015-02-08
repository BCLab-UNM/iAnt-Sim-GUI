#import "AppDelegate.h"

NSString *FILE_PATH = @"~/Desktop";
int NUM_ITERATIONS = 10;

@implementation AppDelegate

@synthesize simView;

-(void) applicationDidFinishLaunching:(NSNotification *)aNotification
{
    Simulation* simulation = [[Simulation alloc] init];
    
    [simView setSimulation:simulation];
    
    [simulation setRobotCount:1];
    [simulation setTeamCount:1];
    [simulation setGenerationCount:50];
    [simulation setTagCount:256];
    [simulation setEvaluationCount:1];
    [simulation setClusteringTagCutoff:-1];
    
    [simulation setDistributionClustered:1.];
    [simulation setDistributionPowerlaw:0.];
    [simulation setDistributionRandom:0.];
    
    NSString *parameterFilePath = [NSString stringWithFormat:@"%@/evolvedParameters.plist",[FILE_PATH stringByExpandingTildeInPath]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:parameterFilePath]) {
        [simulation setParameterFile:parameterFilePath];
    }
    
    [simulation setDelegate:self];
    [simulation setTickRate:.005f];
    [simulation setViewDelegate:(NSObject*)simView];
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        [simulation run];
    });
}

@end
