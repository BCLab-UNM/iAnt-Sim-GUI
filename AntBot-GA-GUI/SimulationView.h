#import <Cocoa/Cocoa.h>
#import <AntBot-GA/GA.h>

@class Tag;

@interface SimulationView : NSView {}

-(void) updateAnts:(NSMutableArray*)_ants tags:(NSMutableArray*)_tags pheromones:(NSMutableArray*)_pheromones;

@property (nonatomic) NSMutableArray* ants;
@property (nonatomic) NSMutableArray* tags;
@property (nonatomic) NSMutableArray* pheromones;

@end
