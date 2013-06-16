#import <Cocoa/Cocoa.h>
#import "AntBot-GA/Sim.h"

@interface SimulationView : NSView {
    NSTimer* drawTimer;
}

-(void) updateDisplayWindowWithRobots:(NSMutableArray*)_robots team:(Team*)_team tags:(Array2D*)_tags pheromones:(NSMutableArray*)_pheromones;
-(void) redraw;

@property (nonatomic) Simulation* simulation;
@property (nonatomic) NSMutableArray* robots;
@property (nonatomic) Team* team;
@property (nonatomic) Array2D* tags;
@property (nonatomic) NSMutableArray* pheromones;

@end