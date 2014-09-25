#import <Cocoa/Cocoa.h>
#import "AntBot-GA/Sim.h"

@interface SimulationView : NSView {
    NSTimer* drawTimer;
}

#ifdef __cplusplus
-(void) updateDisplayWindowWithRobots:(NSMutableArray*)_robots team:(Team*)_team grid:(std::vector<std::vector<Cell*> >)_grid pheromones:(NSMutableArray*)_pheromones regions:(NSMutableArray*)_regions clusters:(NSMutableArray *)_clusters;
@property (nonatomic) std::vector<std::vector<Cell*>> grid;
#endif

-(void) redraw;

@property (nonatomic) Simulation* simulation;
@property (nonatomic) NSMutableArray* robots;
@property (nonatomic) Team* team;
@property (nonatomic) NSMutableArray* pheromones;
@property (nonatomic) NSMutableArray* regions;
@property (nonatomic) NSMutableArray* clusters;

@end