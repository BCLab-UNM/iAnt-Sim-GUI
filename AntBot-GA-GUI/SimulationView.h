#import <Cocoa/Cocoa.h>
#import <AntBot-GA/GA.h>

@class Tag;

@interface SimulationView : NSView {}

-(void) updateRobots:(NSMutableArray*)_robots tags:(NSMutableArray*)_tags pheromones:(NSMutableArray*)_pheromones;

@property (nonatomic) NSMutableArray* robots;
@property (nonatomic) NSMutableArray* tags;
@property (nonatomic) NSMutableArray* pheromones;

@end
