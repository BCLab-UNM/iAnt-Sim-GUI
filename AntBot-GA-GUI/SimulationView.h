#import <Cocoa/Cocoa.h>
#import <AntBot-GA/GA.h>

@class Tag;

@interface SimulationView : NSView {}

-(void) updateDisplayWindowWithRobots:(NSMutableArray*)_robots team:(Team*)_team tags:(Array2D*)_tags pheromones:(NSMutableArray*)_pheromones;

@property (nonatomic) NSMutableArray* robots;
@property (nonatomic) Team* team;
@property (nonatomic) Array2D* tags;
@property (nonatomic) NSMutableArray* pheromones;

@end
